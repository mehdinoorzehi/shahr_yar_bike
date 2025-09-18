import 'dart:async';
import 'package:bike/app_routes.dart';
import 'package:bike/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool showBike = true;
  bool _navigated = false; // ✅ برای جلوگیری از چند بار ناوبری

  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  late AnimationController _textController;
  late Animation<double> _textAnimation;

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

    // شروع delayed
    Future.delayed(const Duration(milliseconds: 3300), () {
      if (!mounted || _navigated) {
        return; // اگر صفحه dispose شده یا کاربر زودتر رفت، کاری نکن
      }
      _runAnimations();
    });
  }

  void _runAnimations() {
    if (!mounted) return;
    setState(() {
      showBike = false;
    });
    _logoController.forward();
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted || _navigated) return;
      _textController.forward();
    });
  }

  void _goNext() {
    if (_navigated) return;
    _navigated = true;
    Get.offAllNamed(AppRoutes.guidance);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        child: Stack(
          children: [
            Center(
              child: showBike
                  ? Lottie.asset('assets/anim/bike.json', repeat: false)
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScaleTransition(
                          scale: _logoAnimation,
                          child: Image.asset(
                            "assets/img/logo2.png",
                            width: 120,
                          ),
                        ),
                        FadeTransition(
                          opacity: _textAnimation,
                          child: Image.asset(
                            "assets/img/logo3.png",
                            width: 200,
                          ),
                        ),
                      ],
                    ),
            ),
            Positioned(
              bottom: 60.0,
              left: 40.0,
              right: 40.0,
              child: SizedBox(
                width: double.infinity,
                height: 60.0,
                child: MyButton(
                  buttonText: 'شروع کنید',
                  onTap: () {
                    _goNext(); // ✅ فوراً به صفحه بعد
                  },
                ),
              ),
            ),
            const Positioned(
              bottom: 10.0,
              left: 1.0,
              right: 0.0,
              child: Text(
                'نسخه تست 6',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
