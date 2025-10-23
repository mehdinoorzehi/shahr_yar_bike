import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

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
                    'اخبار و اطلاع رسانی',
                    style: TextStyle(
                      color: _theme.colorScheme.onPrimary,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: Container(
            //     width: Get.width,
            //     decoration: BoxDecoration(
            //       borderRadius: const BorderRadius.only(
            //         topLeft: Radius.circular(50),
            //         topRight: Radius.circular(50),
            //       ),
            //       color: _theme.colorScheme.surface,
            //     ),
            //     child: SingleChildScrollView(
            //       physics: const BouncingScrollPhysics(),
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 10,
            //           vertical: 30,
            //         ),
            //         child: Column(
            //           children: [
            //             const SizedBox(height: 350),
            //             MyButton(buttonText: 'اشتراک گذاری', onTap: () {}),
            //             const SizedBox(height: 10),
            //             MyButton(buttonText: 'مخاطبین', onTap: () {}),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// class _InviteCard extends StatelessWidget {
//   const _InviteCard({required ThemeData theme}) : _theme = theme;

//   final ThemeData _theme;

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: Get.height * 0.18,
//       left: 0,
//       right: 0,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 20,
//         ), // فاصله از چپ و راست
//         child: Container(
//           height: 380,
//           decoration: BoxDecoration(
//             color: _theme.colorScheme.onPrimary,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: _theme.colorScheme.secondary.withValues(alpha: 0.25),
//                 blurRadius: 1,
//                 spreadRadius: 1.5,,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Stack(
//             clipBehavior: Clip.none,
//             children: [
//               // 📌 پترن فقط گوشه بالا-چپ
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 child: Image.asset(
//                   'assets/img/pattern4.png',
//                   height: 300,
//                   fit: BoxFit.contain,
//                 ),
//               ),

//               // 📌 Rider در مرکز کارت
//               Positioned(
//                 top: 40,
//                 left: 0,
//                 right: 0,
//                 child: Center(
//                   child: Image.asset(
//                     'assets/img/rider.png',
//                     width: 150,
//                     height: 130,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),

//               // 📌 متن کد دعوت
//               Positioned(
//                 bottom: 40,
//                 left: 0,
//                 right: 0,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('کد دعوت شما', style: _theme.textTheme.titleSmall),
//                     const SizedBox(height: 12),
//                     Text(
//                       'KD08CS2006',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: _theme.colorScheme.primary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
