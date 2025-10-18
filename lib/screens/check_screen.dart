import 'package:bike/app_routes.dart';
import 'package:bike/controllers/initial_controller.dart';
import 'package:bike/widgets/animated_background.dart';
import 'package:bike/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  bool appInstalled = false;
  final checkServerController = Get.find<InitialController>();

  void _goNext() {
    Get.toNamed(AppRoutes.onBoarding);
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
                  onPressed: () {
                    Get.snackbar(
                      "راهنما",
                      "لطفاً تنظیمات دستگاه خود را بررسی کنید.",
                      backgroundColor: Colors.black87,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.amberAccent,
                  ),
                  child: Text(guideText),
                )
              else
                const SizedBox(),
              ElevatedButton.icon(
                onPressed: onCheck,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOk ? Colors.greenAccent : Colors.redAccent,
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
                        isOk ? 'checked'.tr : 'check'.tr,
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
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
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.15),
            blurRadius: 7,
            spreadRadius: 1,
          ),
        ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.snackbar(
                      "راهنمای نصب",
                      "از منوی مرورگر، گزینه Add to Home Screen را بزنید.",
                      backgroundColor: Colors.black87,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appInstalled
                        ? Colors.greenAccent
                        : Colors.blueAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: appInstalled
                      ? const Icon(Icons.check, size: 18)
                      : const SizedBox(),
                  label: Text(
                    appInstalled ? 'نصب شده' : 'install'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
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
        // ✅ نمایش دکمه Continue فقط وقتی هر دو اوکی باشند
        bottomNavigationBar: Obx(() {
          final allOk =
              checkServerController.serverOk.value &&
              checkServerController.currentPosition.value != null;

          if (!allOk) return const SizedBox();

          return Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
            child: MyButton(
              isFocus: true,
              buttonText: 'continue'.tr,
              onTap: _goNext,
            ),
          );
        }),
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ✅ کارت سرور
                Obx(() {
                  final ctrl = checkServerController;
                  return _buildCard(
                    title: "server_connection".tr,
                    description: ctrl.message.value.isNotEmpty
                        ? ctrl.message.value
                        : "در حال بررسی اتصال به سرور...",
                    isOk: ctrl.serverOk.value,
                    onCheck: ctrl.checkServerConnection,
                    guideText: "help".tr,
                    showGuide:
                        !ctrl.serverOk.value, // ✅ اگر اوکی نبود راهنما نشون بده
                    isLoading: ctrl.serverLoading.value,
                  );
                }),

                // ✅ کارت لوکیشن
                Obx(() {
                  final ctrl = checkServerController;
                  String desc = "location_gps_message".tr;
                  if (ctrl.locationErrorMessage.value.isNotEmpty) {
                    desc = ctrl
                        .locationErrorMessage
                        .value; // ✅ متن خطا جایگزین میشه
                  }

                  return _buildCard(
                    title: "location".tr,
                    description: desc,
                    isOk: ctrl.currentPosition.value != null,
                    onCheck: ctrl.checkLocation,
                    guideText: "help".tr,
                    showGuide:
                        ctrl.currentPosition.value == null, // ✅ در صورت خطا
                    isLoading: ctrl.locationLoading.value,
                  );
                }),

                _buildInstallCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
