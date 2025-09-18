import 'package:bike/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  int? selectedIndex; // اندیس کارت انتخاب‌شده
  final List<String> amounts = ['5,000 ت', '10,000 ت', '30,000 ت', '50,000 ت'];

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    final gradientBorder = LinearGradient(
      colors: [_theme.colorScheme.primary, _theme.colorScheme.secondary],
    );

    return Scaffold(
      body: Container(
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
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(bottom: 20),
              height: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'افزایش موجودی',
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
            Expanded(
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: _theme.colorScheme.surface,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 30,
                    ),
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          alignment: WrapAlignment.center,
                          children: List.generate(amounts.length, (index) {
                            final isSelected = selectedIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // کانتینر گرادیانت برای بوردر
                                  Container(
                                    width: 140,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? gradientBorder
                                          : null,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                        3,
                                      ), // ضخامت بوردر
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: _theme.colorScheme.shadow
                                                .withValues(alpha: 0.2),
                                          ),
                                          // boxShadow: const [
                                          //   BoxShadow(
                                          //     color: Colors.black26,
                                          //     blurRadius: 1,
                                          //     spreadRadius: 1.5,
                                          //   ),
                                          // ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            amounts[index],
                                            style: _theme.textTheme.titleSmall,
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      top: -10,
                                      right: -10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: _theme.colorScheme.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          LucideIcons.check,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 50),
                        const Divider(),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: ListTile(
                            leading: Icon(
                              LucideIcons.banknote,
                              color: _theme.colorScheme.primary,
                            ),
                            title: Text(
                              'روش پرداخت',
                              style: _theme.textTheme.titleMedium,
                            ),
                            trailing: SizedBox(
                              height: 35,
                              width: 80,
                              child: MyButton(
                                buttonText: 'انتخاب',
                                onTap: () {},
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 80),
                        MyButton(
                          buttonText: 'افزایش موجودی',
                          onTap: () {
                            if (selectedIndex != null) {}
                          },
                        ),
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
}
