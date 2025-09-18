import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:toastification/toastification.dart';

// Future<void> _playSound() async {
//   final player = AudioPlayer();
//   await player.play(AssetSource('sounds/bing.mp3'));
// }

void showSuccsesToast({required String description}) {
  // _playSound();
  toastification.show(
    type: ToastificationType.success,
    style: ToastificationStyle.flatColored,
    title: const Text(
      'موفقیت آمیز!',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        // color: secondaryColor,
      ),
    ),
    direction: TextDirection.rtl,
    description: Text(
      description,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ),
    alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 5),
    icon: const Icon(LucideIcons.circle_check),
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
    direction: TextDirection.rtl,
    style: ToastificationStyle.flatColored,
    title: const Text(
      'خطا!',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        // color: secondaryColor,
      ),
    ),
    description: Text(
      description,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ),
    alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 5),
    icon: const Icon(LucideIcons.circle_x),
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
    style: ToastificationStyle.flatColored,
    title: const Text(
      'توجه!',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        // color: secondaryColor,
      ),
    ),
    direction: TextDirection.rtl,
    description: Text(
      description,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ),
    alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 5),
    icon: const Icon(LucideIcons.info),
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
    direction: TextDirection.rtl,
    title: const Text(
      'هشدار!',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        // color: secondaryColor,
      ),
    ),
    description: Text(
      description,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ),
    alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 5),
    icon: const Icon(LucideIcons.circle_alert),
    borderRadius: BorderRadius.circular(12.0),
    showProgressBar: true,
    dragToClose: true,
  );
}
