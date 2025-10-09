import 'dart:async';
import 'package:bike/app_routes.dart';
import 'package:bike/widgets/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _navigated = false;

  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  late AnimationController _textController;
  late Animation<double> _textAnimation;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 0), () {
      if (!mounted || _navigated) return;
      _runAnimations();
    });

    _textController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_navigated) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted && !_navigated) _goNext();
        });
      }
    });
  }

  void _runAnimations() {
    if (!mounted) return;

    _logoController.forward();
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted || _navigated) return;
      _textController.forward();
    });
  }

  void _goNext() {
    if (_navigated) return;
    _navigated = true;

    _pulseController.stop();
    _logoController.stop();
    _textController.stop();

    Future.microtask(() {
      if (!mounted) return;
      _pulseController.dispose();
      _logoController.dispose();
      _textController.dispose();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Get.offNamed(AppRoutes.onBoarding);
      });
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    _pulseController.removeListener(() {});
    _logoController.removeListener(() {});
    _textController.removeListener(() {});

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Column(
                  key: const ValueKey("next"),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🎇 آیکون با پالس و نور
                    ScaleTransition(
                      scale: _logoAnimation,
                      child: ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            "assets/img/logo2.png",
                            width: 120,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _textAnimation,
                      child: Image.asset("assets/img/logo3.png", width: 200),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'dart:async';
// import 'package:bike/app_routes.dart';
// import 'package:bike/widgets/animated_background.dart';
// import 'package:bike/widgets/button.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   bool showBike = true;
//   bool _navigated = false;

//   late AnimationController _logoController;
//   late Animation<double> _logoAnimation;

//   late AnimationController _textController;
//   late Animation<double> _textAnimation;

//   late AnimationController _pulseController;
//   late Animation<double> _pulseAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _logoController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     );
//     _logoAnimation = CurvedAnimation(
//       parent: _logoController,
//       curve: Curves.easeOut,
//     );

//     _textController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     );
//     _textAnimation = CurvedAnimation(
//       parent: _textController,
//       curve: Curves.easeIn,
//     );

//     // ✅ انیمیشن پالس (حرکت رفت و برگشت)
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);

//     _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );

//     // شروع delayed
//     Future.delayed(const Duration(milliseconds: 6100), () {
//       if (!mounted || _navigated) {
//         return;
//       }
//       _runAnimations();
//     });
//   }

//   void _runAnimations() {
//     if (!mounted) return;
//     setState(() {
//       showBike = false;
//     });
//     _logoController.forward();
//     Future.delayed(const Duration(seconds: 1), () {
//       if (!mounted || _navigated) return;
//       _textController.forward();
//     });
//   }

//   void _goNext() {
//     if (_navigated) return;
//     _navigated = true;
//     Get.toNamed(AppRoutes.onBoarding);
//   }

//   @override
//   void dispose() {
//     _logoController.dispose();
//     _textController.dispose();
//     _pulseController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBackground(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Stack(
//           children: [
//             Center(
//               child: AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 800),
//                 transitionBuilder: (Widget child, Animation<double> animation) {
//                   return FadeTransition(opacity: animation, child: child);
//                 },
//                 child: showBike
//                     ? SizedBox(
//                         key: const ValueKey("bike"),
//                         height: 250,
//                         width: 250,
//                         child: Lottie.asset(
//                           'assets/anim/bike.json',
//                           repeat: false,
//                           onLoaded: (composition) {
//                             Future.delayed(composition.duration, () {
//                               if (mounted && showBike) {
//                                 setState(() {
//                                   showBike = false;
//                                 });
//                                 _logoController.forward();
//                                 Future.delayed(const Duration(seconds: 1), () {
//                                   if (mounted) _textController.forward();
//                                 });
//                               }
//                             });
//                           },
//                         ),
//                       )
//                     : Column(
//                         key: const ValueKey("next"),
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // 🎇 آیکون با پالس و نور
//                           ScaleTransition(
//                             scale: _logoAnimation,
//                             child: ScaleTransition(
//                               scale: _pulseAnimation,
//                               child: Container(
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   // boxShadow: [
//                                   //   BoxShadow(
//                                   //     color: Colors.white.withValues(alpha:0.6),
//                                   //     blurRadius: 25,
//                                   //     spreadRadius: 15,
//                                   //   ),
//                                   // ],
//                                 ),
//                                 child: Image.asset(
//                                   "assets/img/logo2.png",
//                                   width: 120,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           FadeTransition(
//                             opacity: _textAnimation,
//                             child: Image.asset(
//                               "assets/img/logo3.png",
//                               width: 200,
//                             ),
//                           ),
//                         ],
//                       ),
//               ),
//             ),

//             /// 👇 زبان
//             Positioned(
//               bottom: 60.0,
//               left: 40.0,
//               right: 40.0,
//               child: Column(
//                 children: [
//                   LanguageSelector(
//                     onSelect: (langCode) {
//                     },
//                   ),
//                   const SizedBox(height: 80),
//                 ],
//               ),
//             ),

//             /// 👇 دکمه
//             Positioned(
//               bottom: 60.0,
//               left: 40.0,
//               right: 40.0,
//               child: MyButton(
//                 isFocus: true,
//                 buttonText: 'شروع کنید',
//                 onTap: () {
//                   _goNext();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

