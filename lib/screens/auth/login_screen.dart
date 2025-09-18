import 'package:bike/app_routes.dart';
import 'package:bike/widgets/button.dart';
import 'package:bike/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _theme.colorScheme.primary,
              _theme.colorScheme.secondary,
              _theme.colorScheme.secondary,
              _theme.colorScheme.secondary,
              _theme.colorScheme.secondary,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 200,
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(bottom: 20, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'خوش آمدید !',
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
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: _theme.colorScheme.surface,
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'شماره‌ات رو وارد کن تا سریع وارد بشی',
          style: themeData.textTheme.titleSmall,
        ),

        const SizedBox(height: 24),
        MyTextFeild(
          keyboardType: TextInputType.phone,
          suffoxIcon: const Icon(LucideIcons.phone),
          hintText: '09',
          textDirection: TextDirection.ltr,
          maxLength: 11,
          onChanged: (value) {
            if (value.length == 11) {
              FocusScope.of(context).nextFocus();
            }
          },
        ),
        const SizedBox(height: 80),

        MyButton(
          buttonText: 'ورود',
          onTap: () {
            Get.offNamed(AppRoutes.otp);
          },
        ),

        const SizedBox(height: 40),

        // 🔹 راهنمای ورود
        TextButton.icon(
          onPressed: () {
            showModalBottomSheet(
              showDragHandle: true,

              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "راهنمای ورود",
                      style: themeData.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "۱. راهنمای یک\n"
                      "۲. راهنمای دو\n"
                      "۳. راهنمای سه",
                      textAlign: TextAlign.start,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("تایید"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },

          icon: const Text("راهنمای ورود"),
          label: const Icon(LucideIcons.circle_help, size: 20),
        ),
      ],
    );
  }
}
