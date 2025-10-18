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
    final ThemeData _theme = Theme.of(context);
    // final checkController = Get.find<UnifiedController>();

    return Scaffold(
      body: AnimatedBackground(
        child: Column(
          children: [
            Container(
              height: 70,
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(bottom: 20, right: 40, left: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'login_title'.tr,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: _theme.colorScheme.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: const Color.fromARGB(
                    255,
                    204,
                    202,
                    202,
                  ).withValues(alpha: 0.4),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
                    child: _Login(themeData: _theme),
                  ),
                ),
              ),
            ),
          ],
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
            child: CircularProgressIndicator(),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'login_description'.tr,
              style: themeData.textTheme.titleSmall!.apply(
                color: themeData.colorScheme.onPrimary,
                fontSizeDelta: 1.1,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 🔸 شماره تلفن
          MyTextFeild(
            controller: authController.phoneController,
            keyboardType: TextInputType.phone,
            suffixIcon: Icon(
              LucideIcons.phone,
              color: themeData.colorScheme.onPrimary,
            ),
            hintTextDirection: TextDirection.ltr,
            hintText: 'phone_placeholder'.tr,
            textDirection: TextDirection.ltr,
            maxLength: 11,
            enableValidation: true, // ✅ فعال کن
            validator: (value) {
              if (value.isEmpty) return 'نباید خالی باشد';
              if (!value.startsWith('09')) return 'شماره باید با 09 شروع شود';
              if (value.length != 11) return 'شماره باید 11 رقم باشد';
              return ''; // یعنی معتبره
            },
          ),
          const SizedBox(height: 32),

          // 🔹 نمایش لیست متدهای تأیید
          if (controller.methods.length > 1)
            Column(
              children: controller.methods.map((method) {
                final isSelected =
                    controller.selectedMethod.value?.method == method.method;
                return GestureDetector(
                  onTap: () => controller.selectedMethod(method),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 16,
                    ),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(16),
                    //   border: Border.all(
                    //     color: isSelected
                    //         ? themeData.colorScheme.primary
                    //         : Colors.white.withValues(alpha: 0.4),
                    //     width: 1.5,
                    //   ),
                    //   color: isSelected
                    //       ? themeData.colorScheme.primary.withValues(
                    //           alpha: 0.15,
                    //         )
                    //       : Colors.white.withValues(alpha: 0.15),
                    // ),
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
                          activeColor: themeData
                              .colorScheme
                              .onPrimary, // رنگ دایره انتخاب‌شده
                          fillColor: WidgetStateProperty.resolveWith<Color>((
                            states,
                          ) {
                            if (states.contains(WidgetState.selected)) {
                              return themeData
                                  .colorScheme
                                  .onPrimary; // رنگ وقتی انتخاب شده
                            }
                            return Colors
                                .white; // 🔹 رنگ دایره وقتی انتخاب نشده
                          }),
                        ),

                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'verification_method.${method.method}'.tr,
                            // method.method.tr,
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

          const SizedBox(height: 60),

          // 🔸 دکمه لاگین
          MyButton(
            isLoading: authController.isLoadingLogin.value,
            buttonText: 'login_button'.tr,
            isFocus: true,
            onTap: () async {
              // از initialController متد انتخاب‌شده را به auth بده
              authController.selectedMethod.value =
                  controller.selectedMethod.value?.method ?? '';

              await authController.requestVerification();
            },
          ),

          const SizedBox(height: 50),

          // نکات پایین فرم
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [..._buildLoginTips(themeData)],
          ),
        ],
      );
    });
  }
}

Widget buildTip(String text, ThemeData themeData) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    // textDirection: TextDirection.rtl,
    children: [
      Icon(
        LucideIcons.circle_check,
        color: themeData.colorScheme.onPrimary.withValues(alpha: 0.85),
        size: 18,
      ),
      const SizedBox(width: 6),
      Flexible(
        child: Text(
          text,
          textDirection: TextDirection.rtl,
          style: themeData.textTheme.bodyMedium!.copyWith(
            color: themeData.colorScheme.onPrimary.withValues(alpha: 0.85),
            height: 1.5,
            fontSize: 13.5,
          ),
        ),
      ),
    ],
  );
}

List<Widget> _buildLoginTips(ThemeData themeData) {
  List<Widget> tips = [];
  int index = 1;

  while (true) {
    final key = 'login_request_help_$index';
    final text = key.tr;

    // اگر کلید خالی یا برابر کلید خودش بود یعنی ترجمه وجود نداره → توقف
    if (text.isEmpty || text == key) break;

    tips.add(buildTip(text, themeData));
    tips.add(const SizedBox(height: 8));

    index++;
  }

  return tips;
}
