import 'package:bike/app_routes.dart';
import 'package:bike/widgets/animated_background.dart';
import 'package:bike/widgets/button.dart';
import 'package:bike/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    return Scaffold(
      body: AnimatedBackground(
        child: Column(
          children: [
            Container(
              height: 200,
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(bottom: 15, right: 40, left: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'login_title'.tr,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: _theme.colorScheme.onPrimary,
                      fontSize: 23,
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

class _Login extends StatelessWidget {
  const _Login({required this.themeData});

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
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
        MyTextFeild(
          keyboardType: TextInputType.phone,
          suffoxIcon: Icon(
            LucideIcons.phone,
            color: themeData.colorScheme.onPrimary,
          ),
          hintTextDirection: TextDirection.ltr,
          hintText: 'phone_placeholder'.tr,
          textDirection: TextDirection.ltr,
          maxLength: 11,
          onChanged: (value) {
            if (value.length == 11) {
              // FocusScope.of(context).nextFocus();
            }
          },
        ),
        const SizedBox(height: 80),

        MyButton(
          buttonText: 'login_button'.tr,
          isFocus: true,
          onTap: () {
            Get.toNamed(AppRoutes.otp);
          },
        ),

        const SizedBox(height: 70),

        // 🔹 دکمه راهنمای ورود موقتاً غیرفعال شد
        // TextButton.icon(
        //   onPressed: () { ... },
        //   icon: Text("راهنمای ورود"),
        //   label: Icon(LucideIcons.circle_question_mark),
        // ),

        // ✅ نکات جذاب و راست‌چین پایین فرم
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTip("۱. شماره باید با 09 شروع شود", themeData),
            const SizedBox(height: 8),
            buildTip("۲. شماره باید به نام خودتان باشد", themeData),
            const SizedBox(height: 8),
            buildTip("۳. امکان تغییر شماره موبایل وجود ندارد", themeData),
          ],
        ),
      ],
    );
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
