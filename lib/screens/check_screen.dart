import 'dart:async';
import 'package:bike/app_routes.dart';
import 'package:bike/controllers/initial_controller.dart';
import 'package:bike/helper/pwa_helper.dart';
import 'package:bike/widgets/animated_background.dart';
import 'package:bike/widgets/button.dart';
import 'package:bike/widgets/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web/web.dart' as web;

class CheckScreen extends StatefulWidget {
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  final checkServerController = Get.find<InitialController>();
  bool _isPwaInstalled = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) _checkPwaStatus();
  }

  Future<void> _checkPwaStatus() async {
    if (!kIsWeb) return;

    try {
      final isStandalone = web.window
          .matchMedia('(display-mode: standalone)')
          .matches;
      final isIOSStandalone =
          (web.window.navigator as dynamic).standalone == true;
      final installedByJs = PWAHelper.instance.isInstalled;

      setState(() {
        _isPwaInstalled = isStandalone || isIOSStandalone || installedByJs;
      });
    } catch (e) {
      debugPrint('[PWA] check error: $e');
    }
  }

  Widget _buildInstallCard() {
    final screenWidth = Get.width;

    return Container(
      width: screenWidth * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        color: Colors.white.withValues(alpha: 0.07),
        backgroundBlendMode: BlendMode.overlay,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'install_webapp'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "install_webapp_message".tr,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: PWAHelper.instance.canInstall
                    ? () async {
                        await PWAHelper.instance.promptInstall();
                        await Future.delayed(const Duration(milliseconds: 800));
                        _checkPwaStatus();
                      }
                    : () =>
                          showInfoToast(description: "install_instructions".tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PWAHelper.instance.canInstall
                      ? Colors.blueAccent
                      : Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.download, size: 18),
                label: Text('install'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // کارت اتصال سرور
                Obx(() {
                  final ctrl = checkServerController;
                  return _buildCard(
                    title: "server_connection".tr,
                    description: ctrl.message.value.isNotEmpty
                        ? ctrl.message.value
                        : "server_checking".tr,
                    isOk: ctrl.serverOk.value,
                    onCheck: ctrl.checkServerConnection,
                    guideText: "help".tr,
                    showGuide: !ctrl.serverOk.value,
                    isLoading: ctrl.serverLoading.value,
                  );
                }),

                // کارت لوکیشن
                Obx(() {
                  final ctrl = checkServerController;
                  final hasError = ctrl.locationErrorMessage.value.isNotEmpty;
                  String desc = '';
                  if (ctrl.locationLoading.value) {
                    desc = 'location_checking'.tr;
                  } else if (ctrl.currentPosition.value != null && !hasError) {
                    desc = 'location_success'.tr;
                  } else if (hasError) {
                    desc = ctrl.locationErrorMessage.value;
                  }

                  return _buildCard(
                    title: "location".tr,
                    description: desc,
                    isOk: ctrl.currentPosition.value != null && !hasError,
                    onCheck: ctrl.checkLocation,
                    guideText: "help".tr,
                    showGuide: hasError,
                    isLoading: ctrl.locationLoading.value,
                  );
                }),

                // کارت نصب وب‌اپ (فقط وقتی نصب نشده)
                if (kIsWeb && !_isPwaInstalled) _buildInstallCard(),
              ],
            ),
          ),
        ),

        bottomNavigationBar: Obx(() {
          final ctrl = checkServerController;
          final allOk =
              ctrl.serverOk.value &&
              ctrl.currentPosition.value != null &&
              ctrl.locationErrorMessage.value.isEmpty;

          if (!allOk) return const SizedBox();

          return Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
            child: MyButton(
              isFocus: true,
              buttonText: 'continue'.tr,
              onTap: () => Get.toNamed(AppRoutes.onBoarding),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String description,
    required bool isOk,
    required VoidCallback? onCheck,
    required String guideText,
    bool showGuide = false, // ✅ اضافه شد
    bool isLoading = false,
  }) {
    final screenWidth = Get.width;

    return Container(
      width: screenWidth * 0.9,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        color: Colors.white.withValues(alpha: 0.07),
        backgroundBlendMode: BlendMode.overlay,
        boxShadow: [
          BoxShadow(
            color: isOk
                ? Colors.greenAccent.withValues(alpha: 0.5)
                : Colors.redAccent.withValues(alpha: 0.4),
            blurRadius: 7,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showGuide) // ✅ فقط در صورت نیاز نمایش داده شود
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.amberAccent,
                  ),
                  child: Text(guideText),
                )
              else
                const SizedBox(),
              if (!isOk || isLoading)
                ElevatedButton.icon(
                  onPressed: onCheck,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOk
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: isOk
                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                      : const SizedBox(),
                  label: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : Text(
                          isOk ? 'check_again'.tr : 'check'.tr,
                          style: const TextStyle(color: Colors.white),
                        ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
