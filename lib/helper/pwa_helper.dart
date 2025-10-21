// lib/helper/pwa_helper.dart
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import 'pwa_js_interop.dart';

class PWAHelper {
  static final PWAHelper instance = PWAHelper._();

  PWAHelper._();

  /// آیا مرورگر اجازه نصب PWA را می‌دهد؟
  bool get canInstall {
    if (!kIsWeb) return false;
    try {
      return PwaJsInterop.canInstall();
    } catch (_) {
      return false;
    }
  }

  /// آیا اپ به‌صورت PWA نصب شده؟
  bool get isInstalled {
    if (!kIsWeb) return false;
    try {
      return PwaJsInterop.isInstalled();
    } catch (_) {
      return false;
    }
  }

  /// درخواست نصب PWA از کاربر
  Future<void> promptInstall() async {
    if (!kIsWeb) return;
    try {
      final choice = await PwaJsInterop.promptInstall();
      if (kDebugMode) {
        print('[PWAHelper] promptInstall result: $choice');
      }
    } catch (e) {
      if (kDebugMode) print('[PWAHelper] promptInstall error: $e');
    }
  }

  /// 🔹 تشخیص اینکه آیا مرورگر روی iOS است
  bool get isIOS {
    if (!kIsWeb) return false;
    try {
      final userAgent = web.window.navigator.userAgent.toLowerCase();
      return userAgent.contains('iphone') ||
          userAgent.contains('ipad') ||
          userAgent.contains('ipod');
    } catch (_) {
      return false;
    }
  }

  /// 🔹 تشخیص اینکه مرورگر Safari است
  bool get isSafari {
    if (!kIsWeb) return false;
    try {
      final ua = web.window.navigator.userAgent.toLowerCase();
      final isSafari = ua.contains('safari') && !ua.contains('chrome');
      return isSafari;
    } catch (_) {
      return false;
    }
  }

  /// 🔹 تشخیص اینکه مرورگر Chrome روی iOS است
  bool get isChromeOnIOS {
    if (!kIsWeb) return false;
    try {
      final ua = web.window.navigator.userAgent.toLowerCase();
      return isIOS && ua.contains('crios');
    } catch (_) {
      return false;
    }
  }
}
