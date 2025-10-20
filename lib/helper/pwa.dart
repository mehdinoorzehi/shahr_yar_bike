import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';

extension _EventJS on JSObject {
  external void preventDefault();
  external JSPromise get userChoice;
  external void prompt();
}

class PWAInstallHelper {
  static final PWAInstallHelper instance = PWAInstallHelper._internal();
  PWAInstallHelper._internal();

  JSObject? _deferredPrompt;
  bool canInstall = false;

  void init() {
    if (!kIsWeb) return;

    try {
      web.window.addEventListener(
        'beforeinstallprompt',
        ((web.Event e) {
          // جلوگیری از prompt خودکار مرورگر
          (e as JSObject).preventDefault();
          _deferredPrompt = e as JSObject;
          canInstall = true;
          print('✅ beforeinstallprompt event captured');
        }).toJS,
      );
    } catch (e) {
      print('⚠️ Error adding beforeinstallprompt listener: $e');
    }
  }

  Future<void> promptInstall() async {
    if (!canInstall || _deferredPrompt == null) {
      print('❌ Install not available.');
      return;
    }

    try {
      _deferredPrompt!.prompt();

      final choice = await _deferredPrompt!.userChoice.toDart;
      print('🔹 userChoice: $choice');

      _deferredPrompt = null;
      canInstall = false;
    } catch (e) {
      print('⚠️ Install failed: $e');
    }
  }
}
