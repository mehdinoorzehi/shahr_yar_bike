import 'package:bike/app_routes.dart';
import 'package:bike/widgets/question_box_dialog.dart';
import 'package:bike/widgets/animated_touch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Drawer(
      child: Container(
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
        child: Column(
          children: [
            // 🔹 بخش بالای پروفایل + آیکون بستن
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 50, bottom: 20),
                  child: const Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/img/profile.png'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'مهدی نورزهی',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'کد ملی: 1234567890',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'شماره موبایل: 09140750087',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // 🔹 آیکون بستن بالا سمت چپ
                Positioned(
                  top: 15,
                  left: 10,
                  child: IconButton(
                    icon: Icon(
                      LucideIcons.power,
                      color: _theme.colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => QueastionBoxDialog(
                          title: 'آیا می خواهید از حساب خود خارج شوید؟',
                          yesOnTap: () {},
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // 🔹 لیست منو
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _theme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _drawerItem(
                        icon: LucideIcons.user,
                        text: 'حساب کاربری',
                        onTap: () {
                          Get.toNamed(AppRoutes.profile);
                        },
                        context: context,
                      ),
                      _drawerItem(
                        icon: LucideIcons.wallet,
                        text: 'کیف پول من',
                        onTap: () => Get.toNamed(AppRoutes.wallet),
                        context: context,
                      ),
                      _drawerItem(
                        icon: LucideIcons.map_pinned,
                        text: 'گزارش سفر ها',
                        onTap: () => Get.toNamed(AppRoutes.travelReports),
                        context: context,
                      ),
                      _drawerItem(
                        icon: LucideIcons.newspaper,
                        text: 'اخبار و اطلاع رسانی',
                        onTap: () => Get.toNamed(AppRoutes.inviteFriends),
                        context: context,
                      ),
                      _drawerItem(
                        icon: LucideIcons.message_circle_heart,
                        text: 'پشتیبانی',
                        onTap: () => Get.toNamed(AppRoutes.support),
                        context: context,
                      ),
                      _drawerItem(
                        icon: LucideIcons.settings,
                        text: 'تنظیمات',
                        onTap: () => Get.toNamed(AppRoutes.settings),
                        context: context,
                      ),
                      _drawerItem(
                        icon: LucideIcons.log_out,
                        text: 'خروج از حساب',
                        color: Colors.red,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => QueastionBoxDialog(
                              title: 'آیا می خواهید از حساب خود خارج شوید؟',
                              yesOnTap: () {},
                            ),
                          ); // کد خروج از حساب
                        },
                        context: context,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String text,
    Color? color,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedTouch(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color:
                  color ??
                  Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.3),
            ),
          ),
          child: ListTile(
            leading: Icon(
              icon,
              color: color,
              //?? Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              text,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: color,
                // ?? Theme.of(context).colorScheme.primary,
              ),
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
