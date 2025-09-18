import 'dart:ui';
import 'package:bike/controllers/main_controller.dart';
import 'package:bike/screens/category_list.dart';
import 'package:bike/widgets/drawer_avatar.dart';
import 'package:bike/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        endDrawer: const MyDrawer(),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _theme.colorScheme.primary,
                _theme.colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              // ====== HEADER ======
              Builder(
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        const DrawerAvatar(),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Scaffold.of(context).openEndDrawer(),
                          child: Text(
                            'سلام مهدی',
                            style: _theme.textTheme.titleLarge!.apply(
                              color: _theme.colorScheme.onPrimary,
                              fontSizeFactor: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => Scaffold.of(context).openEndDrawer(),
                          child: Icon(
                            LucideIcons.menu,
                            color: _theme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // ====== WEATHER CARD ======
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: RepaintBoundary(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 3,
                        sigmaY: 3,
                      ), // سبک‌تر شد
                      child: Container(
                        decoration: BoxDecoration(
                          color: _theme.colorScheme.onPrimary.withValues(
                            alpha: 0.2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/img/cloudly.png',
                              width: 80,
                              height: 65,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '12°',
                                  style: _theme.textTheme.titleLarge!.apply(
                                    color: _theme.colorScheme.onPrimary,
                                    fontWeightDelta: 2,
                                  ),
                                ),
                                Text(
                                  'اصفهان',
                                  style: _theme.textTheme.bodyLarge!.apply(
                                    color: _theme.colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  'چهارشنبه، 17 دی',
                                  style: _theme.textTheme.bodyMedium!.apply(
                                    color: _theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ====== HORIZONTAL ICON CARDS ======
              SizedBox(
                height: 110,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildMiniCard(_theme, LucideIcons.bike, "دوچرخه"),
                      _buildMiniCard(_theme, LucideIcons.smile, "اسکوتر"),
                      _buildMiniCard(_theme, LucideIcons.bike, "دوچرخه برقی"),
                      _buildMiniCard(
                        _theme,
                        LucideIcons.circle_parking,
                        "پارکینگ",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ====== CURRENT TRIP CARD ======
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _theme.colorScheme.primary.withValues(alpha: 0.5),
                        _theme.colorScheme.secondary.withValues(alpha: 0.9),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: _theme.colorScheme.shadow.withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black.withValues(alpha: 0.15),
                    //     blurRadius: 1, // سبک‌تر شد
                    //     offset: const Offset(0, 6),
                    //   ),
                    // ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            LucideIcons.bike,
                            color: _theme.colorScheme.onPrimary,
                            size: 35,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "سفر جاری",
                            style: _theme.textTheme.titleLarge!.apply(
                              color: _theme.colorScheme.onPrimary,
                              fontWeightDelta: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _tripInfo(
                            _theme,
                            LucideIcons.clock,
                            "مدت زمان",
                            "32 دقیقه",
                          ),
                          _tripInfo(
                            _theme,
                            LucideIcons.wallet,
                            "هزینه",
                            "45,000 تومان",
                          ),
                          _tripInfo(
                            _theme,
                            LucideIcons.bike,
                            "شماره پلاک",
                            "22",
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _theme.colorScheme.onPrimary,
                          foregroundColor: _theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(LucideIcons.check),
                        label: const Text("پایان سفر"),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ====== TITLE ROW ======
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.chevron_left,
                      color: _theme.colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        final controller = Get.find<MainController>();
                        controller.selectedIndex.value = 1; // تب نقشه
                      },
                      child: Text(
                        'جستجو در نقشه',
                        style: _theme.textTheme.titleMedium!.apply(
                          color: _theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),

                    const Spacer(),
                    Text(
                      'پیشنهادات',
                      style: _theme.textTheme.titleMedium!.apply(
                        color: _theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              const NearStationCards(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniCard(ThemeData theme, IconData icon, String title) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15), // حالت شیشه‌ای روشن
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3), // بوردر محو
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: theme.colorScheme.onPrimary, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.bodyMedium!.apply(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tripInfo(ThemeData theme, IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.onPrimary, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          textDirection: TextDirection.rtl,
          style: theme.textTheme.bodyMedium!.apply(
            color: theme.colorScheme.onPrimary,
            fontWeightDelta: 2,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall!.apply(
            fontSizeFactor: 1.3,
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
