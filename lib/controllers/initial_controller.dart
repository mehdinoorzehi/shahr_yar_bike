import 'package:bike/helper/go_to_check_screen.dart';
import 'package:bike/langs/translation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bike/helper/location_helper.dart';
import 'package:bike/api/api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class VerificationMethod {
  final String method;

  VerificationMethod({required this.method});

  factory VerificationMethod.fromJson(Map<String, dynamic> json) {
    return VerificationMethod(method: json['method'] ?? '');
  }
}

class InitialController extends GetxController {
  // -------------------- 🛰️ چک سرور و لوکیشن --------------------
  var serverLoading = false.obs;
  var locationLoading = false.obs;

  final Rxn<Position> currentPosition = Rxn<Position>();
  var serverOk = false.obs;
  final RxString message = ''.obs;

  // ✅ پیام خطای لوکیشن برای نمایش در کارت
  final RxString locationErrorMessage = ''.obs;

  // -------------------- 🔑 لاگین --------------------
  final RxList<VerificationMethod> methods = <VerificationMethod>[].obs;
  final Rx<VerificationMethod?> selectedMethod = Rx<VerificationMethod?>(null);
  final RxBool isLoginLoading = false.obs;

  // -------------------- 🚀 آن‌بوردینگ --------------------
  final RxInt totalPages = 0.obs;
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
    _calculateOnboardingPages(); // ✅ محاسبه خودکار صفحات آن‌بوردینگ
  }

  // -------------------- محاسبه تعداد صفحات از ترجمه‌ها --------------------
  void _calculateOnboardingPages() {
    int count = 0;
    while (true) {
      final pic = 'onboarding_pic_${count + 1}'.tr;
      final title = 'onboarding_title_${count + 1}'.tr;
      final desc = 'onboarding_desc_${count + 1}'.tr;

      if (pic.startsWith('onboarding_') &&
          title.startsWith('onboarding_') &&
          desc.startsWith('onboarding_')) {
        break;
      }
      count++;
    }

    totalPages.value = count;
    debugPrint("✅ Onboarding pages detected: $count");
  }

  // -------------------- 🧩 تجمیع بررسی‌ها --------------------
  Future<void> fetchAllData() async {
    await checkServerConnection();
    await checkLocation();
  }

  // -------------------- 🌐 بررسی اتصال سرور --------------------
  Future<void> checkServerConnection() async {
    serverLoading.value = true;
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      // ignore: unrelated_type_equality_checks
      if (connectivityResult == ConnectivityResult.none) {
        message.value = 'internet_connection_error'.tr;
        serverOk.value = false;
        return;
      }

      final response = await ApiService.get('/init');
      if (response == null) {
        message.value = 'server_response_error'.tr;
        serverOk.value = false;
        return;
      }

      message.value = response['message'] ?? 'server_response_error'.tr;
      serverOk.value = response['ok'] == true;

      // ✅ بررسی نسخه‌ی ترجمه‌ها
      if (response['translations_build_at'] != null) {
        final int serverBuildAt = response['translations_build_at'];
        final localeKey =
            TranslationService.to.currentLocale.value.languageCode;

        // مقدار generated_at فعلی
        final int localGeneratedAt =
            TranslationService.to.generatedAt[localeKey] ?? 0;

        debugPrint(
          "🕓 Server build: $serverBuildAt | Local generated: $localGeneratedAt",
        );

        // اگر نسخه‌ی سرور جدیدتر بود، ترجمه‌ی جدید دریافت کن
        if (serverBuildAt > localGeneratedAt) {
          debugPrint("🔁 New translations detected → fetching...");
          await TranslationService.to.changeLanguageByApiCode(
            localeKey,
            force: true,
          );
          Get.updateLocale(Locale(localeKey));
          message.value = message.value.tr; // 👈 بروزرسانی با ترجمه جدید
        } else {
          debugPrint("✅ Local translations are up-to-date.");
        }
      }

      // ✅ متدهای ورود
      if (response['verification_methods'] != null) {
        final list = response['verification_methods'] as List;
        final parsed = list.map((m) => VerificationMethod.fromJson(m)).toList();
        methods.assignAll(parsed);
        if (parsed.isNotEmpty) {
          selectedMethod.value = parsed.first;
        }
      }
    } catch (e) {
      message.value = 'server_connection_error';
      serverOk.value = false;
      debugPrint("❌ خطا در checkServerConnection: $e");
    } finally {
      serverLoading.value = false;
    }
  }

  // -------------------- 🧭 بررسی موقعیت --------------------
  Future<void> checkLocation() async {
    locationLoading.value = true;
    locationErrorMessage.value = ''; // پاک‌سازی پیام قبلی

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locationErrorMessage.value = 'location_disabled'.tr;
        goToCheckScreen();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        locationErrorMessage.value = 'location_restricted'.tr;
        goToCheckScreen();
        return;
      }

      final pos = await safeGetCurrentPosition();
      if (pos == null) {
        locationErrorMessage.value = 'location_error'.tr;
        goToCheckScreen();
        return;
      }

      // ✅ موفقیت در گرفتن موقعیت
      currentPosition.value = pos;
      locationErrorMessage.value = ''; // پاک‌سازی پیام خطا
    } catch (e) {
      locationErrorMessage.value = 'location_error'.tr;
      goToCheckScreen();
      debugPrint("❌ خطا در checkLocation: $e");
    } finally {
      locationLoading.value = false;
    }
  }

  // -------------------- 📄 کنترل آن‌بوردینگ --------------------
  void setCurrentPage(int index) => currentPage.value = index;

  Future<void> nextPage(VoidCallback onFinished) async {
    if (currentPage.value < totalPages.value - 1) {
      await pageController.animateToPage(
        currentPage.value + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      onFinished();
    }
  }

  String getOnboardingImagePath(int index) {
    final translated = 'onboarding_pic_${index + 1}'.tr;
    if (translated.isEmpty || translated.startsWith('onboarding_')) return '';
    return translated;
  }

  bool isNetworkImage(int index) {
    final translated = 'onboarding_pic_${index + 1}'.tr;
    return translated.startsWith('http');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
