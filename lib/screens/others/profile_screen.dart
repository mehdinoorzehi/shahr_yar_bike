import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // 🎨 گرادیانت بک‌گراند
          Container(
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
                ],
              ),
            ),
          ),

          // 🔹 هدر بالای صفحه
          Container(
            height: 200,
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.only(bottom: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'حساب کاربری',
                  style: TextStyle(
                    color: _theme.colorScheme.onPrimary,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    LucideIcons.arrow_right,
                    color: _theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 لایه سفید پایین
          Positioned.fill(
            top: 180,
            child: Container(
              decoration: BoxDecoration(
                color: _theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
            ),
          ),

          // 🔹 محتوای اصلی
          Positioned.fill(
            top: 140,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // 🟢 کارت اصلی پروفایل
                    profileCard(_theme),

                    const SizedBox(height: 20),

                    // 🟣 باکس‌های اطلاعات کاربر
                    infoBox(
                      _theme,
                      icon: LucideIcons.id_card,
                      title: "کد ملی",
                      value: "1234567890",
                    ),
                    infoBox(
                      _theme,
                      icon: LucideIcons.phone,
                      title: "شماره موبایل",
                      value: "09140750087",
                    ),

                    const SizedBox(height: 20),

                    modernInfoBox(
                      _theme,
                      title: "موجودی",
                      value: "24،000 تومان",
                      icon: LucideIcons.banknote,
                    ),

                    const SizedBox(height: 5),
                    // 🔵 باکس مدرن با خط کناری
                    modernInfoBox(
                      _theme,
                      title: "عضویت",
                      value: "کاربر ویژه از 1402",
                      icon: LucideIcons.award,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🟢 کارت پروفایل اصلی
  Widget profileCard(ThemeData _theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _theme.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: _theme.colorScheme.shadow.withValues(alpha: 0.15),
            width: 1.5,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: _theme.shadowColor.withValues(alpha: 0.2),
          //     blurRadius: 1,
          //     offset: const Offset(0, 5),
          //   ),
          // ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 40,
              // backgroundImage: AssetImage(
              //   "assets/images/avatar.png",
              // ), // 📌 عکس پروفایل
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("مهدی نورزهی", style: _theme.textTheme.titleLarge),
                  const SizedBox(height: 5),
                  Text("09140750087", style: _theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🟣 باکس اطلاعات کاربر
  Widget infoBox(
    ThemeData _theme, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: _theme.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: _theme.colorScheme.secondary, width: 0.4),
        ),
        child: Row(
          children: [
            Icon(icon, color: _theme.colorScheme.primary, size: 28),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: _theme.textTheme.titleSmall?.copyWith(
                      color: _theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(value, style: _theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔵 باکس مدرن با خط کناری رنگی
  Widget modernInfoBox(
    ThemeData _theme, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: _theme.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _theme.colorScheme.shadow.withValues(alpha: 0.15),
            width: 1.5,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: _theme.shadowColor.withValues(alpha: 0.15),
          //     blurRadius: 1,
          //     offset: const Offset(0, 4),
          //   ),
          // ],
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 5,
              decoration: BoxDecoration(
                color: _theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(width: 15),
            Icon(icon, color: _theme.colorScheme.secondary, size: 28),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: _theme.textTheme.titleSmall?.copyWith(
                      color: _theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(value, style: _theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
