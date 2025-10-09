import 'package:bike/app_routes.dart';
import 'package:bike/widgets/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      "imageStack": [
        {
          "asset": 'assets/img/map.png',
          "width": 278.1,
          "height": 305.0,
          "pos": null,
        },
        {
          "asset": 'assets/img/bike.png',
          "width": 223.0,
          "height": 139.0,
          "pos": null,
        },
      ],
      "title": "onboarding_title_1".tr,
      "desc": "onboarding_desc_1".tr,
    },
    {
      "imageStack": [
        {
          "asset": 'assets/img/phone.png',
          "width": 179.0,
          "height": 242.0,
          "pos": 0.2,
        },
        {
          "asset": 'assets/img/bike.png',
          "width": 223.0,
          "height": 139.0,
          "pos": 0.2,
        },
      ],
      "title": "onboarding_title_2".tr,
      "desc": "onboarding_desc_2".tr,
    },
    {
      "imageStack": [
        {
          "asset": 'assets/img/rider.png',
          "width": 232.0,
          "height": 225.0,
          "pos": 0.2,
        },
      ],
      "title": "onboarding_title_3".tr,
      "desc": "onboarding_desc_3".tr,
    },
  ];

  // ✅ تابع ناوبری ایمن
  void _safeNavigate(String route) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Get.offNamed(route);
    });
  }

  // ✅ تابع رفتن به صفحه بعد یا ورود
  Future<void> _nextPage() async {
    if (_currentPage < _pages.length - 1) {
      if (!_pageController.hasClients) return;

      try {
        await _pageController.animateToPage(
          _currentPage + 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } catch (_) {
        // جلوگیری از خطا در صورت dispose شدن
      }
    } else {
      _safeNavigate(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: Stack(
          children: [
            // Image.asset("assets/img/pattern.png", fit: BoxFit.contain),
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return Column(
                        children: [
                          const SizedBox(height: 40),

                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Stack(
                              alignment: Alignment.center,
                              children: page["imageStack"].map<Widget>((img) {
                                final double? width = img["width"] != null
                                    ? (img["width"] as num).toDouble()
                                    : null;
                                final double? height = img["height"] != null
                                    ? (img["height"] as num).toDouble()
                                    : null;
                                final double? pos = img["pos"] != null
                                    ? (img["pos"] as num).toDouble()
                                    : null;

                                final imageWidget = Image.asset(
                                  img["asset"],
                                  width: width,
                                  height: height,
                                );

                                return pos != null
                                    ? Positioned(
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                            pos,
                                        child: imageWidget,
                                      )
                                    : imageWidget;
                              }).toList(),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40.0,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      page["title"],
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.titleLarge!.apply(
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      page["desc"],
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            height: 1.5,
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
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
                            onPressed: () => _safeNavigate(AppRoutes.login),
                            child: Text(
                              'skip'.tr,
                              style: theme.textTheme.titleMedium!.apply(
                                color: theme.colorScheme.onPrimary,
                                fontSizeFactor: 0.8,
                              ),
                            ),
                          ),
                        ),
                        // دایره‌ها (هماهنگ با reverse)
                        Row(
                          children: List.generate(_pages.length, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _currentPage == index
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
                            onPressed: _nextPage,
                            child: Text(
                              _currentPage == _pages.length - 1
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
            ),
          ],
        ),
      ),
    );
  }
}
