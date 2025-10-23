import 'package:bike/app_routes.dart';
import 'package:bike/widgets/button.dart';
import 'package:bike/screens/others/item_of_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';

class Walletscreen extends StatelessWidget {
  const Walletscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

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
              _theme.colorScheme.secondary,
              _theme.colorScheme.secondary,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              height: 100,
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
                    'کیف پول من',
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
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: _theme.colorScheme.onPrimary,
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
                        _WalletCard(theme: _theme),

                        const SizedBox(height: 40),
                        const Divider(),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: ListTile(
                            leading: Icon(
                              LucideIcons.banknote,
                              color: _theme.colorScheme.primary,
                            ),
                            title: Text(
                              'اشتراک',
                              style: _theme.textTheme.titleMedium,
                            ),
                            subtitle: Text(
                              'یک ساله',
                              style: _theme.textTheme.titleMedium,
                            ),
                            trailing: SizedBox(
                              height: 35,
                              width: 80,
                              child: MyButton(
                                buttonText: 'تمدید',
                                onTap: () {},
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.only(right: 15, bottom: 10),
                          alignment: Alignment.topRight,
                          child: Text(
                            'لیست تراکنش ها',
                            style: _theme.textTheme.titleMedium,
                          ),
                        ),
                        ...List.generate(
                          10,
                          (index) => const ItemOfTransaction(),
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

class _WalletCard extends StatelessWidget {
  const _WalletCard({required ThemeData theme}) : _theme = theme;

  final ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5), // فاصله از چپ و راست
      child: Container(
        height: 196,
        decoration: BoxDecoration(
          color: _theme.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _theme.colorScheme.secondary.withValues(alpha: 0.4),
            width: 1.5,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: _theme.colorScheme.secondary.withValues(alpha: 0.25),
          //     blurRadius: 1,
          //     spreadRadius: 1.5,
          //     offset: const Offset(0, 4),
          //   ),
          // ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 📌 پترن فقط در گوشه چپ پایین
            Positioned(
              left: -10,
              top: 0,
              child: Image.asset(
                'assets/img/pattern2.png',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
              ),
            ),

            // 📌 Rider
            Positioned(
              left: 25,
              top: 25,
              child: Image.asset(
                'assets/img/rider.png',
                width: 110,
                height: 90,
                fit: BoxFit.contain,
              ),
            ),

            // 📌 متن و دکمه
            Positioned(
              right: 15,
              top: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('موجودی', style: _theme.textTheme.bodyLarge),
                  const SizedBox(height: 15),
                  Text(
                    '24,000 تومان',
                    textDirection: TextDirection.rtl,
                    style: _theme.textTheme.titleMedium,
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 40,
                    width: 110,
                    child: MyButton(
                      buttonText: 'افزایش',
                      onTap: () {
                        Get.toNamed(AppRoutes.topUp);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
