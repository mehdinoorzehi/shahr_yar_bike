import 'package:bike/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

// Future<void> _playSound() async {
//   final player = AudioPlayer();
//   await player.play(AssetSource('sounds/bing.mp3'));
// }

void showSuccessToast({required String description}) {
  // _playSound();
  toastification.show(
    type: ToastificationType.success,
    style: ToastificationStyle.flatColored,
    alignment: Alignment.topCenter,

    title: Text(
      'success'.tr,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        // color: secondaryColor,
      ),
    ),
    // direction: TextDirection.rtl,
    description: Text(
      description,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ),
    // alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 5),
    icon: const Icon(LucideIcons.circle_check, color: kGreen),
    borderRadius: BorderRadius.circular(12.0),
    showProgressBar: true,
    dragToClose: true,
  );
}

//
void showErrorToast({required String description}) {
  // _playSound();

  toastification.show(
    type: ToastificationType.error,
    alignment: Alignment.topCenter,

    // direction: TextDirection.rtl,
    style: ToastificationStyle.flatColored,
    title: Text(
      'error'.tr,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        // color: secondaryColor,
      ),
    ),
    description: Text(
      description,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ),
    // alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 5),
    icon: const Icon(LucideIcons.circle_x, color: kRed),
    borderRadius: BorderRadius.circular(12.0),
    showProgressBar: true,
    dragToClose: true,
  );
}

//
void showInfoToast({required String description}) {
  // _playSound();

  toastification.show(
    type: ToastificationType.info,
    alignment: Alignment.topCenter,
    style: ToastificationStyle.flatColored,
    title: Text(
      'attention'.tr,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        // color: secondaryColor,
      ),
    ),
    // direction: TextDirection.rtl,
    description: Text(
      description,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ),
    // alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 5),
    icon: const Icon(LucideIcons.info, color: kBlue),
    borderRadius: BorderRadius.circular(12.0),
    showProgressBar: true,
    dragToClose: true,
  );
}

//
void showWarningToast({required String description}) {
  // _playSound();

  toastification.show(
    type: ToastificationType.warning,
    style: ToastificationStyle.flatColored,
    alignment: Alignment.topCenter,

    // direction: TextDirection.rtl,
    title: Text(
      'warning'.tr,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        // color: secondaryColor,
      ),
    ),
    description: Text(
      description,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ),
    // alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 5),
    icon: const Icon(LucideIcons.circle_alert, color: kOrange),
    borderRadius: BorderRadius.circular(12.0),
    showProgressBar: true,
    dragToClose: true,
  );
}
