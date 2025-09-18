import 'package:bike/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';

class AmarScreen extends StatelessWidget {
  const AmarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      body: Container(
        height: Get.height,
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
              _theme.colorScheme.secondary,
              _theme.colorScheme.secondary,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 110,
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(bottom: 10, right: 15),
              child: Text(
                'آمار من',
                style: TextStyle(
                  color: _theme.colorScheme.onPrimary,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: Get.width,

                decoration: BoxDecoration(
                  color: _theme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),

                        amarBox(
                          _theme,
                          LucideIcons.clock,
                          'تعداد سفر ها',
                          '30 سفر',
                          _theme.colorScheme.error,
                        ),
                        amarBox(
                          _theme,
                          LucideIcons.clock,
                          'زمان',
                          '24 دقیقه',
                          _theme.colorScheme.secondary,
                        ),
                        amarBox(
                          _theme,
                          LucideIcons.flag_triangle_right,
                          'مسافت',
                          '3235 متر',
                          const Color(0xffFF9500),
                        ),
                        amarBox(
                          _theme,
                          LucideIcons.flame,
                          'کالری',
                          '32 کالری',
                          const Color(0xffFF2D55),
                        ),

                        amarBox(
                          _theme,
                          LucideIcons.leaf,
                          'کربن',
                          '24',
                          _theme.colorScheme.primary,
                        ),
                        // const SizedBox(height: 30),
                        MyButton(buttonText: 'اشتراک گذاری', onTap: () {}),
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

  Padding amarBox(
    ThemeData _theme,
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 25),
      child: Container(
        decoration: BoxDecoration(
          color: _theme.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _theme.colorScheme.secondary.withValues(alpha: 0.5),
            width: 1.5,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: _theme.colorScheme.secondary,
          //     blurRadius: 1,
          //     spreadRadius: 1.5,
          //   ),
          // ],
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: Icon(icon, size: 30, color: iconColor),
            title: Text(title, style: _theme.textTheme.titleSmall),
            subtitle: Text(subtitle, style: _theme.textTheme.titleLarge),
          ),
        ),
      ),
    );
  }
}
