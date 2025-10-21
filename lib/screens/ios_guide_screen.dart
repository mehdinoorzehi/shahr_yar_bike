import 'package:flutter/material.dart';
// import 'package:web/web.dart' as web;

class IOSGuideScreen extends StatelessWidget {
  const IOSGuideScreen({super.key});

  // bool get _isIOS {
  //   final userAgent = web.window.navigator.userAgent.toLowerCase();
  //   return userAgent.contains('iphone') ||
  //       userAgent.contains('ipad') ||
  //       userAgent.contains('ipod');
  // }

  @override
  Widget build(BuildContext context) {
    // if (!_isIOS) {
    //   // اگر کاربر iOS نیست، چیزی نمایش نده
    //   return const SizedBox.shrink();
    // }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // 🔹 لوگو بالای صفحه
            Image.asset('assets/img/logo4.png', width: 200),

            const SizedBox(height: 24),

            // 🔹 توضیح بالایی
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'وب‌اپلیکیشن شهریار را به صفحه اصلی تلفن همراه خود اضافه کنید',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 50),

            // 🔹 ستون مراحل
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _StepItem(
                    icon: Icons.ios_share,
                    title: 'Share',
                    subtitle: 'انتخاب این گزینه از نوار پایین',
                  ),
                  SizedBox(height: 40),
                  _StepItem(
                    icon: Icons.add,
                    title: 'Add to Home Screen',
                    subtitle: 'انتخاب این گزینه از منوی ظاهر شده',
                  ),
                  SizedBox(height: 40),
                  _StepItem(
                    isAppLogo: true,
                    title: 'Add',
                    subtitle: 'زدن این گزینه',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

// 🔸 ویجت اختصاصی هر مرحله
class _StepItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;
  final bool isAppLogo;

  const _StepItem({
    this.icon,
    required this.title,
    required this.subtitle,
    this.isAppLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          // آیکون یا لوگو
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey.shade200,
            child: isAppLogo
                ? Image.asset('assets/img/logo5.png', width: 32, height: 32)
                : Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
          ),
          const SizedBox(width: 16),

          // عنوان و توضیح
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
