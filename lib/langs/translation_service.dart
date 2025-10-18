import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'app_translations.dart';

class TranslationService extends GetxService {
  static TranslationService get to => Get.find();

  SharedPreferences? _prefs;
  final String _apiBase = 'https://bike.sirjan.ir/demo/api/translations';
  final Map<String, int> generatedAt = {}; // localeKey -> generated_at
  int getGeneratedAt(String key) => generatedAt[key] ?? 0;

  bool get hasSavedLocaleSync =>
      _prefs?.containsKey('selected_locale') ?? false;

  /// ✅ Reactive locale (for GetX to rebuild UI)
  final Rx<Locale> currentLocale = const Locale('fa', 'IR').obs;

  // ---------------------------------------------------------------------------
  // ✅ Initialization
  // ---------------------------------------------------------------------------
  Future<TranslationService> init() async {
    _prefs = await SharedPreferences.getInstance();

    // 🔹 چک می‌کنیم آیا اولین اجرای برنامه است
    final isFirstRun = _prefs?.getBool('first_run_translations') ?? true;

    if (isFirstRun) {
      debugPrint("🚀 First launch → clearing only translation-related data...");

      // 🔸 فقط کلیدهای مرتبط با ترجمه و زبان حذف می‌شوند
      final keysToRemove = _prefs!.getKeys().where(
        (key) => key.startsWith('translations_') || key == 'selected_locale',
      );

      for (final key in keysToRemove) {
        await _prefs?.remove(key);
      }

      // ✅ علامت می‌زنیم که دیگر اولین اجرا نیست
      await _prefs?.setBool('first_run_translations', false);

      // 🔹 سپس زبان فارسی را از سرور می‌گیریم
      try {
        debugPrint("🌍 Fetching Persian translations (first run)...");
        await changeLanguageByApiCode('fa', force: true);
        debugPrint("✅ Persian translations downloaded and applied.");
      } catch (e) {
        debugPrint("⚠️ Failed to fetch FA translations on first launch: $e");
      }
    }

    // -------------------------------------------------------------------------
    // ادامه‌ی روند معمول
    final savedKey = _prefs?.getString('selected_locale');

    if (savedKey != null) {
      currentLocale.value = _localeFromKey(savedKey);
    }

    final key = _localeKey(currentLocale.value);
    final cached = _prefs?.getString('translations_$key');

    if (cached != null) {
      try {
        final parsed = jsonDecode(cached) as Map<String, dynamic>;
        final map = Map<String, String>.from(parsed['translations'] ?? {});
        AppTranslations.setLocaleMap(key, map);

        generatedAt[key] = parsed['generated_at'] is int
            ? parsed['generated_at']
            : int.tryParse('${parsed['generated_at']}') ?? 0;
      } catch (e) {
        debugPrint("⚠️ Failed to load cached translations: $e");
      }
    }

    Get.updateLocale(currentLocale.value);
    return this;
  }

  // ---------------------------------------------------------------------------
  // ✅ Helpers
  // ---------------------------------------------------------------------------
  String _localeKey(Locale l) =>
      '${l.languageCode}${l.countryCode != null ? "_${l.countryCode}" : ""}';

  Locale _localeFromKey(String key) {
    final parts = key.split('_');
    if (parts.length == 2) return Locale(parts[0], parts[1]);
    return Locale(parts[0]);
  }

  Locale _localeFromApiCode(String code) {
    switch (code) {
      case 'fa':
        return const Locale('fa');
      case 'ar':
        return const Locale('ar');
      case 'en':
        return const Locale('en');
      default:
        return Locale(code);
    }
  }

  // ---------------------------------------------------------------------------
  // ✅ Change Language (with server fetch + cache fallback)
  // ---------------------------------------------------------------------------
  Future<bool> changeLanguageByApiCode(
    String apiCode, {
    bool force = false,
  }) async {
    final locale = _localeFromApiCode(apiCode);
    final key = _localeKey(locale);
    final uri = Uri.parse('$_apiBase/$apiCode');

    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(res.body);
        final int gen = body['generated_at'] is int
            ? body['generated_at']
            : int.tryParse('${body['generated_at']}') ?? 0;

        // ✅ Check version (only update if newer)
        if (!force &&
            generatedAt.containsKey(key) &&
            gen <= (generatedAt[key] ?? 0) &&
            AppTranslations().keys.containsKey(key)) {
          _applyLocale(locale, key);
          return true;
        }

        final Map<String, String> translationsMap = Map<String, String>.from(
          body['translations'] ?? {},
        );

        // ✅ Update runtime translations
        AppTranslations.setLocaleMap(key, translationsMap);
        generatedAt[key] = gen;

        // ✅ Save cache
        await _prefs?.setString('translations_$key', res.body);
        await _prefs?.setString('selected_locale', key);

        _applyLocale(locale, key);
        return true;
      } else {
        return _applyCacheIfExists(key, locale);
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching translations: $e");
      return _applyCacheIfExists(key, locale);
    }
  }

  // ---------------------------------------------------------------------------
  // ✅ Apply cache if server fails
  // ---------------------------------------------------------------------------
  bool _applyCacheIfExists(String key, Locale locale) {
    final cached = _prefs?.getString('translations_$key');
    if (cached == null) return false;

    try {
      final parsed = jsonDecode(cached) as Map<String, dynamic>;
      final Map<String, String> translationsMap = Map<String, String>.from(
        parsed['translations'] ?? {},
      );

      AppTranslations.setLocaleMap(key, translationsMap);

      generatedAt[key] = parsed['generated_at'] is int
          ? parsed['generated_at']
          : int.tryParse('${parsed['generated_at']}') ?? 0;

      _applyLocale(locale, key);
      return true;
    } catch (e) {
      debugPrint("⚠️ Failed to apply cached translation: $e");
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // ✅ Centralized locale updater (Reactive + persistent)
  // ---------------------------------------------------------------------------
  void _applyLocale(Locale locale, String key) {
    currentLocale.value = locale; // Reactive update
    Get.updateLocale(locale); // Apply immediately in UI
    _prefs?.setString('selected_locale', key); // Persist
  }
}
