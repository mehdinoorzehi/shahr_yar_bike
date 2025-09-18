import 'package:bike/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
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
      "title": "دوچرخه‌تو پیدا کن",
      "desc":
          "نقشه رو باز کن و نزدیک‌ترین دوچرخه رو پیدا کن، آماده‌ای برای یه سفر؟",
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
      "title": "قفل رو باز کن",
      "desc": "بارکد قفل رو اسکن کن یا شماره‌اش رو بزن… قفل باز میشه",
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
      "title": "راه بیفت و لذت ببر",
      "desc": "وقتشه مسیرتو شروع کنی… و از هر لحظه‌اش لذت ببری",
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed( AppRoutes.login);
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

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,

      body: Stack(
        children: [
          Image.asset("assets/img/pattern.png", fit: BoxFit.contain),
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  reverse: true,
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  page["title"],
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  page["desc"],
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    height: 1.5,
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
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // بعدی / شروع
                      TextButton(
                        onPressed: _nextPage,
                        child: Text(
                          _currentPage == _pages.length - 1 ? 'شروع' : 'بعدی',
                          style: theme.textTheme.titleMedium!.apply(
                            color: theme.colorScheme.primary,
                            fontSizeFactor: 0.9,
                          ),
                        ),
                      ),
                      // دایره‌ها (هماهنگ با reverse)
                      Row(
                        children: List.generate(_pages.length, (index) {
                          final reversedIndex = _pages.length - 1 - index;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _currentPage == reversedIndex
                                  ? Colors.black
                                  : Colors.grey.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),

                      // رد کردن
                      TextButton(
                        onPressed: () => Get.offAllNamed(AppRoutes.login),
                        child: Text(
                          'رد کردن',
                          style: theme.textTheme.titleMedium!.apply(
                            color: theme.colorScheme.primary,
                            fontSizeFactor: 0.9,
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
    );
  }
}
