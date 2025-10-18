import 'dart:js_interop';

import 'package:web/web.dart' as web;
import 'package:get/get.dart';
import 'package:flutter/material.dart';

void setupWebUpdateChecker() {
  web.window.onLoad.listen((event) {
    web.window.navigator.serviceWorker.ready.then((registration) {
      registration.update();
      registration.addEventListener('updatefound', (event) {
        Future.delayed(const Duration(seconds: 1), () {
          _showUpdateDialog();
        });
      });
    });
  });
}

extension on JSPromise<web.ServiceWorkerRegistration> {
  void then(Null Function(dynamic registration) param0) {}
}

void _showUpdateDialog() {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "بروزرسانی جدید",
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: const Text(
        "نسخه جدید برنامه در دسترس است. لطفاً صفحه را بروزرسانی کنید.",
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.refresh, color: Colors.white),
          label: const Text("بروزرسانی", style: TextStyle(color: Colors.white)),
          onPressed: () {
            web.window.location.reload();
          },
        ),
      ],
    ),
    barrierDismissible: false,
  );
}
