import 'package:bike/widgets/button.dart';
import 'package:bike/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';

class SendRequestScreen extends StatelessWidget {
  const SendRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

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
              padding: const EdgeInsets.only(bottom: 10),
              height: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      LucideIcons.arrow_right,
                      color: _theme.colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    'ارسال درخواست',
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
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: _theme.colorScheme.surface,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 30,
                    ),
                    child: Column(
                      children: [
                        const MyTextFeild(
                          suffixIcon: Icon(LucideIcons.user),
                          hintText: 'نام',
                          hintColor: Colors.grey,
                          hintTextDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 20),
                        const MyTextFeild(
                          keyboardType: TextInputType.phone,
                          suffixIcon: Icon(LucideIcons.phone),
                          hintText: 'شماره تماس',
                          hintTextDirection: TextDirection.rtl,
                          textDirection: TextDirection.ltr,
                          hintColor: Colors.grey,
                        ),
                        const SizedBox(height: 20),

                        const MyTextFeild(
                          suffixIcon: Icon(LucideIcons.mail),
                          hintText: 'متن درخواست',
                          hintTextDirection: TextDirection.rtl,
                          hintColor: Colors.grey,
                        ),

                        const SizedBox(height: 80),
                        MyButton(buttonText: 'ارسال', onTap: () {}),
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
