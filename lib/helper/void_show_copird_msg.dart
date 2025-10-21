import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCopiedMessage(String message) {
  Get.rawSnackbar(
    messageText: Text(
      message,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.black.withValues(alpha: 0.7),
    snackStyle: SnackStyle.FLOATING,
    borderRadius: 12,
    margin: const EdgeInsets.only(bottom: 40, left: 60, right: 60),
    duration: const Duration(seconds: 1),
    isDismissible: false,
    animationDuration: const Duration(milliseconds: 250),
  );
}
