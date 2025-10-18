import 'package:bike/app_routes.dart';
import 'package:bike/controllers/initial_controller.dart';
import 'package:bike/widgets/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<InitialController>();

    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          // اگر پاسخی نیامده یا مشکلی بود
          if (
          // controller.imagePaths.isEmpty &&
          controller.serverLoading.value == true) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'processing'.tr,
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  const SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.totalPages.value,
                  onPageChanged: controller.setCurrentPage,
                  itemBuilder: (context, index) {
                    // final image = controller.imagePaths[index];

                    return Column(
                      children: [
                        const SizedBox(height: 40),

                        // بخش تصویر با لودینگ جداگانه
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Builder(
                              builder: (context) {
                                final imagePath = controller
                                    .getOnboardingImagePath(index);
                                final isNetwork = controller.isNetworkImage(
                                  index,
                                );

                                if (imagePath.isEmpty) {
                                  return const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                  );
                                }

                                return isNetwork
                                    ? Image.network(
                                        imagePath,
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.contain,
                                        loadingBuilder:
                                            (context, child, progress) {
                                              if (progress == null) {
                                                return child;
                                              }
                                              return const SizedBox(
                                                width: 60,
                                                height: 60,
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                        errorBuilder: (context, error, stack) =>
                                            const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                      )
                                    : Image.asset(
                                        imagePath,
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stack) =>
                                            const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                      );
                              },
                            ),
                          ),
                        ),

                        // بخش متن‌ها همیشه نمایش داده می‌شود
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'onboarding_title_${index + 1}'.tr,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleLarge!.apply(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'onboarding_desc_${index + 1}'.tr,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    height: 1.5,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // دکمه‌ها و دایره‌های پایین
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // رد کردن
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 1.2,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () => Get.offNamed(AppRoutes.login),
                          child: Text(
                            'skip'.tr,
                            style: theme.textTheme.titleMedium!.apply(
                              color: theme.colorScheme.onPrimary,
                              fontSizeFactor: 0.8,
                            ),
                          ),
                        ),
                      ),

                      // دایره‌های اندیکاتور
                      Row(
                        children: List.generate(controller.totalPages.value, (
                          index,
                        ) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: controller.currentPage.value == index
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onPrimary.withValues(
                                      alpha: 0.3,
                                    ),
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),

                      // بعدی / شروع
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 1.2,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () => controller.nextPage(
                            () => Get.offNamed(AppRoutes.login),
                          ),
                          child: Text(
                            controller.currentPage.value ==
                                    controller.totalPages.value - 1
                                ? 'get_started'.tr
                                : 'next'.tr,
                            style: theme.textTheme.titleMedium!.apply(
                              color: theme.colorScheme.onPrimary,
                              fontSizeFactor: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
