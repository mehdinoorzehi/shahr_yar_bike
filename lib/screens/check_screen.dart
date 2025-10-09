import 'package:bike/app_routes.dart';
import 'package:bike/controllers/check_access_controller.dart';
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
  // bool serverOk = false;
  // bool locationOk = false;
  bool appInstalled = false;
  final checkServerController = Get.find<CheckAccessController>();

  void _goNext() {
    // if (serverOk && locationOk)
    Get.toNamed(AppRoutes.onBoarding);
  }

  Widget _buildCard({
    required String title,
    required String description,
    required bool isOk,
    required VoidCallback? onCheck,
    required String guideText,
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
      child: Padding(
        padding: const EdgeInsets.all(0),
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
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: isOk
                        ? Colors.greenAccent
                        : Colors.redAccent,
                  ),
                  child: Text(guideText),
                ),
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
                          isOk ? 'چک شد' : 'چک کنید',
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
            const Text(
              'نصب وب‌اپلیکیشن',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'برای دسترسی سریع‌تر، این اپ را به صفحه اصلی خود اضافه کنید',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Container(),

                ElevatedButton.icon(
                  onPressed: () {
                    // InstallController.instance.showInstallPrompt();
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
                    appInstalled ? 'نصب شده' : 'نصب کنید',
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 15.0),
          child: MyButton(isFocus: true, buttonText: 'ادامه', onTap: _goNext),
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => _buildCard(
                    title: "ارتباط با سرور",
                    description: checkServerController.message.value,
                    isOk: checkServerController.serverOk.value,
                    onCheck: checkServerController.checkServerConnection,
                    guideText: "راهنما",
                    isLoading: checkServerController.serverLoading.value,
                  ),
                ),
                Obx(
                  () => _buildCard(
                    title: "موقعیت مکانی",
                    description:
                        "برای تشخیص موقعیت شما، لطفاً GPS را فعال کنید.",
                    isOk: checkServerController.currentPosition.value != null,
                    onCheck: checkServerController.checkLocation,
                    guideText: "راهنما",
                    isLoading: checkServerController.locationLoading.value,
                  ),
                ),
                _buildInstallCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
