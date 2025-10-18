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
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: AnimatedBackground(
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
                          color: theme.colorScheme.onPrimary,
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 36, 28, 20),
                        child: _Login(themeData: theme),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
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
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🔹 توضیحات
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

          // 🔹 فیلد شماره تلفن
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
              if (!value.startsWith('09')) return 'شماره باید با 09 شروع شود';
              if (value.length != 11) return 'شماره باید 11 رقم باشد';
              return '';
            },
          ),
          const SizedBox(height: 25),

          // 🔹 لیست متدهای تأیید (در صورت وجود)
          if (controller.methods.length > 1)
            ...controller.methods.map((method) {
              final isSelected =
                  controller.selectedMethod.value?.method == method.method;
              return GestureDetector(
                onTap: () => controller.selectedMethod(method),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Radio<VerificationMethod>(
                        value: method,
                        // ignore: deprecated_member_use
                        groupValue: controller.selectedMethod.value,
                        // ignore: deprecated_member_use
                        onChanged: (val) {
                          if (val != null) controller.selectedMethod(val);
                        },
                        activeColor: themeData.colorScheme.onPrimary,
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          return states.contains(WidgetState.selected)
                              ? themeData.colorScheme.onPrimary
                              : Colors.white;
                        }),
                      ),
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
            }),
          const SizedBox(height: 30),

          // 🔹 دکمه لاگین
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

          const Spacer(),

          // 🔹 نکات پایین صفحه
          _buildTipsSection(themeData),
        ],
      );
    });
  }

  Widget _buildTipsSection(ThemeData themeData) {
    final tips = _buildLoginTips(themeData);
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        Divider(color: themeData.colorScheme.onPrimary.withValues(alpha: 0.3)),
        const SizedBox(height: 16),
        ...tips,
      ],
    );
  }
}

// ✅ ساخت ویجت نکات
Widget buildTip(String text, ThemeData themeData) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          LucideIcons.circle_check,
          color: themeData.colorScheme.onPrimary.withValues(alpha: 0.8),
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            // textDirection: TextDirection.rtl,
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: themeData.colorScheme.onPrimary.withValues(alpha: 0.8),
              height: 1.5,
              fontSize: 13.5,
            ),
          ),
        ),
      ],
    ),
  );
}

List<Widget> _buildLoginTips(ThemeData themeData) {
  final tips = <Widget>[];
  int index = 1;

  while (true) {
    final key = 'login_request_help_$index';
    final text = key.tr;
    if (text.isEmpty || text == key) break;
    tips.add(buildTip(text, themeData));
    index++;
  }

  return tips;
}
