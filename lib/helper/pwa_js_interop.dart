// lib/helper/pwa_js_interop.dart
@JS()
// ignore: unnecessary_library_name
library pwa_js_interop;

import 'package:js/js.dart';

@JS('isInstallablePWA')
external bool _jsIsInstallablePWA();

@JS('promptInstallPWA')
external dynamic _jsPromptInstallPWA(); // ممکنه Promise یا null برگردد

class PwaJsInterop {
  /// آیا تابع JS می‌گوید PWA قابل نصب است؟
  static bool canInstall() {
    try {
      return _jsIsInstallablePWA() == true;
    } catch (e) {
      return false;
    }
  }

  /// درخواست نصب را اجرا کن. نتیجهٔ userChoice (یا null) بازمی‌گردد.
  /// در Dart ممکن است return نوع dynamic باشد؛ آن را بررسی کن.
  static Future<dynamic> promptInstall() async {
    try {
      final res = _jsPromptInstallPWA();
      // اگر JS Promise بازگرداند، آن را به Future تبدیل کن:
      // package:js اجازهٔ await مستقیم به Promise را نمی‌دهد، اما وقتی _jsPromptInstallPWA یک Promise است،
      // calling it in dart gives a JsObject; ساده‌ترین و عملیاتی‌ترین راه این است که JS تابع را طوری بنویسی که خودش Promise را resolve کند
      // و ما اینجا مقدار بازگشت را await کنیم (در عمل در بیشتر حالات _jsPromptInstallPWA() خودش یک Promise-like را در dart به Future تبدیل می‌کند).
      // اما برای ایمنی، اگر res یک Future-like باشد، await می‌کنیم:
      if (res is Future) {
        return await res;
      }
      return res;
    } catch (e) {
      return null;
    }
  }
}
