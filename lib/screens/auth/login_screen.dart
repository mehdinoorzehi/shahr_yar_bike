import 'package:bike/controllers/authentication_controller.dart';
import 'package:bike/controllers/initial_controller.dart';
import 'package:bike/widgets/animated_background.dart';
import 'package:bike/widgets/button.dart';
import 'package:bike/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false, // ❌ صفحه بالا نره
      body: AnimatedBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // 🔹 عنوان صفحه
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'login_title'.tr,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // 🔹 محتوای اصلی
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 1.2,
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: 28,
                        right: 28,
                        top: 36,
                        bottom:
                            MediaQuery.of(context).viewInsets.bottom +
                            20, // ✅ اضافه برای اسکرول پشت کیبورد
                      ),
                      child: _Login(themeData: Theme.of(context)),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Login extends GetView<InitialController> {
  const _Login({required this.themeData});
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthenticationController>();

    return Obx(() {
      if (controller.serverLoading.value) {
        return const Center(
          child: SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // توضیحات
          Center(
            child: Text(
              'login_description'.tr,
              style: themeData.textTheme.titleSmall?.copyWith(
                color: themeData.colorScheme.onPrimary,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // فیلد شماره تلفن
          MyTextFeild(
            controller: authController.phoneController,
            keyboardType: TextInputType.phone,
            suffixIcon: Icon(
              LucideIcons.phone,
              color: themeData.colorScheme.onPrimary,
            ),
            hintText: 'phone_placeholder'.tr,
            hintTextDirection: TextDirection.ltr,
            textDirection: TextDirection.ltr,
            maxLength: 11,
            enableValidation: true,
            validator: (value) {
              if (value.isEmpty) return 'نباید خالی باشد';
              if (!value.startsWith('09')) {
                return 'شماره باید با 09 شروع شود';
              }
              if (value.length != 11) return 'شماره باید 11 رقم باشد';
              return '';
            },
          ),
          const SizedBox(height: 25),

          // 🎯 انتخاب متدهای تایید با طراحی جذاب
          if (controller.methods.length > 1)
            Column(
              children: controller.methods.map((method) {
                final isSelected =
                    controller.selectedMethod.value?.method == method.method;

                return GestureDetector(
                  onTap: () => controller.selectedMethod(method),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? themeData.colorScheme.onPrimary
                            : Colors.white54,
                        width: 1.4,
                      ),
                      color: isSelected
                          ? themeData.colorScheme.onPrimary.withValues(
                              alpha: 0.15,
                            )
                          : Colors.white.withValues(alpha: 0.05),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? LucideIcons.circle_check
                              : LucideIcons.circle,
                          size: 22,
                          color: isSelected
                              ? themeData.colorScheme.onPrimary
                              : Colors.white70,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'verification_method.${method.method}'.tr,
                            style: TextStyle(
                              color: themeData.colorScheme.onPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 30),

          // دکمه لاگین
          MyButton(
            isLoading: authController.isLoadingLogin.value,
            buttonText: 'login_button'.tr,
            isFocus: true,
            onTap: () async {
              authController.selectedMethod.value =
                  controller.selectedMethod.value?.method ?? '';
              await authController.requestVerification();
            },
          ),
          const SizedBox(height: 40),

          // نکات پایین صفحه
          _buildTipsSection(themeData),
        ],
      );
    });
  }
}

// 🔹 بخش نکات پایین
Widget _buildTipsSection(ThemeData theme) {
  final tips = <Widget>[];
  int i = 1;
  while (true) {
    final key = 'login_request_help_$i';
    final text = key.tr;
    if (text.isEmpty || text == key) break;
    tips.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(
              LucideIcons.circle_check,
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                  height: 1.5,
                  fontSize: 13.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    i++;
  }
  return Column(
    children: [
      const SizedBox(height: 100),
      Divider(color: theme.colorScheme.onPrimary.withValues(alpha: 0.3)),
      const SizedBox(height: 16),
      ...tips,
    ],
  );
}
