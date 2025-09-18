import 'package:bike/app_routes.dart';
import 'package:bike/controllers/main_controller.dart';
import 'package:bike/screens/amar_screen.dart';
import 'package:bike/screens/home_screen.dart';
import 'package:bike/screens/map/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final MainController controller = Get.find<MainController>();

  /// فقط یک بار ساخته می‌شود و نگه داشته می‌شود
  final MapScreen _mapScreen = const MapScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            Get.toNamed(AppRoutes.qrScan);
          },
          backgroundColor: theme.colorScheme.primary,
          shape: const CircleBorder(),
          child: Icon(Icons.qr_code, color: theme.colorScheme.onPrimary),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        backgroundColor: theme.colorScheme.primary,

        /// ترکیب lazy load و نگه‌داری MapScreen
        body: Obx(() {
          switch (controller.selectedIndex.value) {
            case 0:
              return const AmarScreen(); // هر بار ساخته میشه
            case 1:
              return _mapScreen; // همیشه همون یک instance
            case 2:
              return const HomeScreen(); // هر بار ساخته میشه
            default:
              return const HomeScreen();
          }
        }),

        bottomNavigationBar: StylishBottomBar(
          fabLocation: StylishBarFabLocation.end,
          notchStyle: NotchStyle.circle,
          option: BubbleBarOptions(
            barStyle: BubbleBarStyle.horizontal,
            bubbleFillStyle: BubbleFillStyle.outlined,
          ),
          backgroundColor: theme.colorScheme.onPrimary,
          items: [
            BottomBarItem(
              icon: const Icon(LucideIcons.chart_column),
              title: const Text('آمار من'),
              selectedColor: theme.colorScheme.primary,
              borderColor: theme.colorScheme.primary,
            ),
            BottomBarItem(
              icon: const Icon(LucideIcons.locate_fixed),
              title: const Text('نقشه'),
              selectedColor: theme.colorScheme.primary,
              borderColor: theme.colorScheme.primary,
            ),
            BottomBarItem(
              icon: const Icon(LucideIcons.house),
              title: const Text('خانه'),
              selectedColor: theme.colorScheme.primary,
              borderColor: theme.colorScheme.primary,
            ),
          ],
          currentIndex: controller.selectedIndex.value,
          onTap: (index) {
            controller.selectedIndex.value = index;
          },
        ),
      ),
    );
  }
}
