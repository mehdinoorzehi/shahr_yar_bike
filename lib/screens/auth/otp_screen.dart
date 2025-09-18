import 'package:bike/app_routes.dart';
import 'package:bike/widgets/button.dart';
import 'package:bike/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themeData.colorScheme.primary,
              themeData.colorScheme.secondary,
              themeData.colorScheme.secondary,
              themeData.colorScheme.secondary,
              themeData.colorScheme.secondary,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(bottom: 20, right: 30),
              height: 200,
              child: Text(
                'کد پیامکی',
                style: TextStyle(
                  color: themeData.colorScheme.onPrimary,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: themeData.colorScheme.surface,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 60,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'لطفا کد ارسال شده به شماره 09140750087 را وارد کنید',
                          style: themeData.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 70,
                              child: MyTextFeild(
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 70,
                              child: MyTextFeild(
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                  if (value.isEmpty) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 70,
                              child: MyTextFeild(
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                  if (value.isEmpty) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 70,
                              child: MyTextFeild(
                                maxLength: 1,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                  if (value.isEmpty) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        TextButton(
                          onPressed: () {},
                          child: const Text('ویرایش شماره'),
                        ),
                        const SizedBox(height: 5),
                        TextButton(
                          onPressed: () {},
                          child: const Text('کد را دریافت نکردید؟'),
                        ),
                        const SizedBox(height: 80),

                        MyButton(
                          buttonText: 'ادامه',
                          onTap: () {
                            Get.offAllNamed(AppRoutes.home);
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
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) => Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "راهنما",
                                      style: themeData.textTheme.titleMedium!
                                          .copyWith(
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
                          icon: const Text("راهنما"),
                          label: const Icon(LucideIcons.circle_help, size: 20),
                        ),
                      ],
                    ),
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
