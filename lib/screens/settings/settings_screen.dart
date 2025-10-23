import 'package:bike/screens/settings/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../theme/mange_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                    'تنظیمات',
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
                        // 🔹 باکس تغییر تم
                        _themeBox(context, _theme),

                        // بقیه باکس‌ها
                        settingsBox(_theme),
                        settingsBox(_theme),
                        settingsBox(_theme),
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

  // 🔹 باکس تغییر تم
  Widget _themeBox(BuildContext context, ThemeData _theme) {
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
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: Icon(
              LucideIcons.palette,
              size: 30,
              color: _theme.colorScheme.primary,
            ),
            title: Text('تغییر تم', style: _theme.textTheme.titleMedium),
            onTap: () {
              _showThemeBottomSheet(context);
            },
          ),
        ),
      ),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // isScrollControlled: false,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "انتخاب تم",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // GridView داخل Column — حتما shrinkWrap و physics رو ست کن
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        // توجه: map<Widget> برای جلوگیری از ابهام
                        children: ThemeType.values.map<Widget>((theme) {
                          final isSelected = themeProvider.themeType == theme;
                          final colors = getThemeColors(theme);
                          final title = getThemeTitle(theme);

                          return GestureDetector(
                            onTap: () {
                              themeProvider.setThemeType(theme);
                              Navigator.pop(context);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? colors.first
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: colors.first.withValues(
                                            alpha: 0.18,
                                          ),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: colors
                                        .map(
                                          (c) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            child: CircleAvatar(
                                              radius: 12,
                                              backgroundColor: c,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: isSelected
                                          ? colors.first
                                          : Colors.black87,
                                    ),
                                  ),
                                  // if (isSelected)
                                  //   const Padding(
                                  //     padding: EdgeInsets.only(top: 6),
                                  //     child: Icon(
                                  //       Icons.check_circle,
                                  //       color: Colors.green,
                                  //       size: 20,
                                  //     ),
                                  //   ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // // 🔹 BottomSheet انتخاب تم
  // void _showThemeBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (_) {
  //       return Directionality(
  //         textDirection: TextDirection.rtl,
  //         child: Consumer<ThemeProvider>(
  //           builder: (context, themeProvider, _) {
  //             return Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 RadioListTile<ThemeMode>(
  //                   value: ThemeMode.light,
  //                   groupValue: themeProvider.themeMode,
  //                   title: const Text("تم روشن"),
  //                   secondary: const Icon(LucideIcons.sun),
  //                   onChanged: (val) {
  //                     themeProvider.setThemeMode(val!);
  //                     Navigator.pop(context);
  //                   },
  //                 ),
  //                 RadioListTile<ThemeMode>(
  //                   value: ThemeMode.dark,
  //                   groupValue: themeProvider.themeMode,
  //                   title: const Text("تم تاریک"),
  //                   secondary: const Icon(LucideIcons.moon),
  //                   onChanged: (val) {
  //                     themeProvider.setThemeMode(val!);
  //                     Navigator.pop(context);
  //                   },
  //                 ),
  //                 RadioListTile<ThemeMode>(
  //                   value: ThemeMode.system,
  //                   groupValue: themeProvider.themeMode,
  //                   title: const Text("بر اساس سیستم"),
  //                   secondary: const Icon(LucideIcons.monitor),
  //                   onChanged: (val) {
  //                     themeProvider.setThemeMode(val!);
  //                     Navigator.pop(context);
  //                   },
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // 🔹 باکس عادی
  Padding settingsBox(ThemeData _theme) {
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
              LucideIcons.settings,
              size: 30,
              color: _theme.colorScheme.primary,
            ),
            title: Text('تنظیمات', style: _theme.textTheme.titleMedium),
          ),
        ),
      ),
    );
  }
}
