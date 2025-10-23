import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';

class TravelReportsScreen extends StatelessWidget {
  const TravelReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    // 📌 دیتا نمونه (لیست سفرها)
    final trips = [
      {
        "mabda": "مسجد جامع",
        "maghsad": "پارک بزرگ شهر",
        "date": "۱۴ مرداد ۱۴۰۳",
        "time": "ساعت ۱۴:۰۰",
        "duration": "۴۵ دقیقه",
        "distance": "۱۲ کیلومتر",
        "price": "۱۰۰۰",
        "rating": 5,
      },
      {
        "mabda": "امیر چخماق",
        "maghsad": "پارک بزرگ شهر",
        "date": "۱۰ مرداد ۱۴۰۳",
        "time": "ساعت ۱۴:۰۰",
        "duration": "۶۰ دقیقه",
        "distance": "۱۵ کیلومتر",
        "price": "۲۰۰۰",
        "rating": 4,
      },
      {
        "mabda": "آتشکده",
        "maghsad": "پارک بزرگ شهر",
        "date": "۸ مرداد ۱۴۰۳",
        "time": "ساعت ۱۴:۰۰",
        "duration": "۹۰ دقیقه",
        "distance": "۲۲ کیلومتر",
        "price": "۶۰۰۰",
        "rating": 5,
      },
      {
        "mabda": "دخمه",
        "maghsad": "پارک بزرگ شهر",
        "date": "۸ مرداد ۱۴۰۳",
        "time": "ساعت ۱۴:۰۰",
        "duration": "۹۰ دقیقه",
        "distance": "۲۲ کیلومتر",
        "price": "۸۰۰۰",
        "rating": 5,
      },
    ];

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
            // 🔹 هدر بالای صفحه
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
                    'گزارش سفر ها',
                    style: TextStyle(
                      color: _theme.colorScheme.onPrimary,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 لایه سفید پایین
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
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      ...trips.map((trip) => tripCard(_theme, trip)),
                      const SizedBox(height: 40),
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

  // 🟢 کارت سفر
  Widget tripCard(ThemeData _theme, Map trip) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_theme.colorScheme.primary, _theme.colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //     color: _theme.shadowColor.withValues(alpha: 0.3),
          //     blurRadius: 1,
          //     offset: const Offset(0, 6),
          //   ),
          // ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                // 🔹 مبدا و تاریخ
                Row(
                  children: [
                    Icon(
                      LucideIcons.map_pin,
                      color: _theme.colorScheme.onPrimary,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        trip["mabda"],
                        style: TextStyle(
                          color: _theme.colorScheme.onPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          trip["date"],
                          style: TextStyle(
                            color: _theme.colorScheme.onPrimary.withValues(
                              alpha: 0.8,
                            ),
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          trip["time"],
                          style: TextStyle(
                            color: _theme.colorScheme.onPrimary.withValues(
                              alpha: 0.8,
                            ),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // 🔹 آمار سفر
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    statItem(
                      _theme,
                      LucideIcons.clock,
                      "مدت زمان",
                      trip["duration"],
                    ),
                    statItem(
                      _theme,
                      LucideIcons.audio_waveform,
                      "مسافت",
                      trip["distance"],
                    ),
                    statItem(
                      _theme,
                      LucideIcons.banknote,
                      "هزینه",
                      trip["price"],
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Text(
                      'مقصد:',
                      style: TextStyle(
                        color: _theme.colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      trip["maghsad"],
                      style: TextStyle(
                        color: _theme.colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // 🔹 امتیاز سفر
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Icon(LucideIcons.star, color: Colors.yellow[700]),
                //     const SizedBox(width: 5),
                //     Text(
                //       "${trip["rating"]} / 5",
                //       style: TextStyle(
                //         color: _theme.colorScheme.onPrimary,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔸 آیتم کوچک آمار
  Widget statItem(ThemeData _theme, IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: _theme.colorScheme.onPrimary, size: 26),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: _theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: _theme.colorScheme.onPrimary.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
