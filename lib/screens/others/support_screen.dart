import 'package:bike/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.sendRequest);
        },
        shape: const CircleBorder(),
        child: const Icon(LucideIcons.plus),
      ),
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
              height: 100,
              padding: const EdgeInsets.only(bottom: 10),
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
                    'پشتیبانی',
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
              child: // لایه کانتینر سفید پایین
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: _theme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: // لایه ستون آمار روی همه چیز
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        supportBox(_theme),
                        supportBox(_theme),
                        supportBox(_theme),
                        supportBox(_theme),
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

  Padding supportBox(ThemeData _theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
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
            leading: Icon(
              LucideIcons.mail,
              size: 30,
              color: _theme.colorScheme.primary,
            ),
            title: Text('عنوان درخواست', style: _theme.textTheme.titleSmall),
            subtitle: Text(
              'متن درخواست متن درخواست متن درخواست متن درخواست متن درخواست',
              style: _theme.textTheme.titleMedium,
            ),
          ),
        ),
      ),
    );
  }
}
