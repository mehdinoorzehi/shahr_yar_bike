// lib/helper/pwa_js_interop.dart
@JS() // اعلان تعامل با JS
// ignore: unnecessary_library_name
library pwa_js_interop;

import 'dart:js_interop';

@JS('isInstallablePWA')
external JSBoolean? _jsIsInstallablePWA();

@JS('promptInstallPWA')
external JSPromise? _jsPromptInstallPWA();

class PwaJsInterop {
  /// بررسی اینکه آیا PWA قابل نصب است یا نه
  static bool canInstall() {
    try {
      final result = _jsIsInstallablePWA();
      return result?.toDart == true;
    } catch (_) {
      return false;
    }
  }

  /// درخواست نصب را اجرا می‌کند و نتیجه userChoice یا null را بازمی‌گرداند.
  static Future<dynamic> promptInstall() async {
    try {
      final promise = _jsPromptInstallPWA();
      if (promise != null) {
        final res = await promise.toDart;
        return res;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
