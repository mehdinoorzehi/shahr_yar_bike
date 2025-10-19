import 'package:bike/app_routes.dart';
import 'package:bike/controllers/initial_controller.dart';
import 'package:bike/widgets/animated_background.dart';
import 'package:bike/widgets/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:pwa_install/pwa_install.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  bool appInstalled = false;
  final checkServerController = Get.find<InitialController>();

  bool showInstallCard = false;

  @override
  void initState() {
    super.initState();
    // _initPwaStatus();
  }

  // Future<void> _initPwaStatus() async {
  //   // setup قبلاً در main انجام شده، فقط وضعیت رو چک می‌کنیم
  //   await Future.delayed(const Duration(milliseconds: 300));

  //   // اگر قابلیت نصب فعال باشه، یعنی هنوز نصب نشده
  //   setState(() {
  //     showInstallCard = PWAInstall().installPromptEnabled;
  //   });
  // }

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
                        isOk ? 'check_again'.tr : 'check'.tr,
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
        boxShadow: const [
          BoxShadow(
            color:
            //  PWAInstall().installPromptEnabled?
                 Colors.transparent,
                // : Colors.greenAccent.withValues(alpha: 0.5),

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
              // PWAInstall().installPromptEnabled
                  // ?
                  "install_webapp_message".tr,
                  // : 'نصب با موفقیت انجام شده است',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                ElevatedButton.icon(
                  onPressed: () async {
                    // if (PWAInstall().installPromptEnabled) {
                    //   PWAInstall().promptInstall_();
                    //   await Future.delayed(const Duration(seconds: 1));
                    //   setState(() {
                    //     showInstallCard = !PWAInstall().installPromptEnabled;
                    //   });
                    // } else {
                    //   showInfoToast(
                    //     description: 'وب‌اپ نصب شده یا نصب ممکن نیست',
                    //   );
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: 
                    // PWAInstall().installPromptEnabled
                        // ? 
                        Colors.blueAccent,
                        // : Colors.greenAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: 
                  // PWAInstall().installPromptEnabled
                  //     ?
                      const Icon(
                          Icons.download,
                          size: 18,
                          color: Colors.white,
                        ),
                      // : const Icon(Icons.check, size: 18, color: Colors.white),
                  label: Text(
                    // PWAInstall().installPromptEnabled
                        // ? 
                        'install'.tr,
                        // : 'نصب شده',
                    style: const TextStyle(color: Colors.white),
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
          final ctrl = checkServerController;
          final allOk =
              ctrl.serverOk.value &&
              ctrl.currentPosition.value != null &&
              ctrl
                  .locationErrorMessage
                  .value
                  .isEmpty; // ✅ بررسی عدم خطای لوکیشن

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
                        : "server_checking".tr,
                    isOk: ctrl.serverOk.value,
                    onCheck: ctrl.checkServerConnection,
                    guideText: "help".tr,
                    showGuide: !ctrl.serverOk.value,
                    isLoading: ctrl.serverLoading.value,
                  );
                }),

                // ✅ کارت لوکیشن
                // ✅ کارت لوکیشن
                Obx(() {
                  final ctrl = checkServerController;
                  final hasError = ctrl.locationErrorMessage.value.isNotEmpty;

                  // توضیحات بر اساس وضعیت
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
                if (kIsWeb && showInstallCard) _buildInstallCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
