// lib/helper/pwa_helper.dart
import 'package:flutter/foundation.dart';
import 'pwa_js_interop.dart';

class PWAHelper {
  static final PWAHelper instance = PWAHelper._();

  PWAHelper._();

  bool get canInstall {
    if (!kIsWeb) return false;
    try {
      return PwaJsInterop.canInstall();
    } catch (_) {
      return false;
    }
  }

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
}
