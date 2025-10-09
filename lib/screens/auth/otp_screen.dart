import 'dart:async';

import 'package:bike/app_routes.dart';
import 'package:bike/screens/auth/login_screen.dart';
import 'package:bike/theme/app_colors.dart';
import 'package:bike/widgets/animated_background.dart';
import 'package:bike/widgets/button.dart';
import 'package:bike/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'dart:math' as math;

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      body: AnimatedBackground(
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(bottom: 20, right: 40, left: 40),
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Text(
                    'کد پیامکی',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: themeData.colorScheme.onPrimary,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: const Color.fromARGB(
                    255,
                    204,
                    202,
                    202,
                  ).withValues(alpha: 0.4),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 60,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'لطفا کد ارسال شده به شماره 09140750087 را وارد کنید',
                            textAlign: TextAlign.center,
                            style: themeData.textTheme.titleSmall!.apply(
                              color: themeData.colorScheme.onPrimary,
                              fontSizeFactor: 1.1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Center(
                          child: SizedBox(
                            width: 200,
                            child: MyTextFeild(
                              maxLength: 6,
                              textDirection: TextDirection.ltr,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        ResendCodeCircle(
                          seconds: 120,
                          onResend: () {
                            // 🔥 ارسال مجدد کد
                          },
                        ),

                        const SizedBox(height: 20),

                        // 🔹 تایمر دایره‌ای وسط
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // 🔹 دکمه ویرایش شماره
                            _GlassButton(
                              icon: LucideIcons.pencil,
                              label: "ویرایش شماره",
                              onTap: () => Get.back(),
                              themeData: themeData,
                            ),

                            // 🔹 دکمه ارسال مجدد کد
                            _GlassButton(
                              themeData: themeData,
                              icon: LucideIcons.refresh_cw,
                              label: "ارسال مجدد کد",
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 80),

                        MyButton(
                          isFocus: true,
                          buttonText: 'ادامه',
                          onTap: () {
                            Get.offAllNamed(AppRoutes.home);
                          },
                        ),
                        const SizedBox(height: 40),

                        const SizedBox(height: 70),

                        // 🔹 دکمه راهنمای ورود موقتاً غیرفعال شد
                        // TextButton.icon(
                        //   onPressed: () { ... },
                        //   icon: Text("راهنمای ورود"),
                        //   label: Icon(LucideIcons.circle_question_mark),
                        // ),

                        // ✅ نکات جذاب و راست‌چین پایین فرم
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTip("۱. شماره باید با 09 شروع شود", themeData),
                            const SizedBox(height: 8),
                            buildTip(
                              "۲. شماره باید به نام خودتان باشد",
                              themeData,
                            ),
                            const SizedBox(height: 8),
                            buildTip(
                              "۳. امکان تغییر شماره موبایل وجود ندارد",
                              themeData,
                            ),
                          ],
                        ),

                        // // 🔹 راهنمای ورود
                        // TextButton.icon(
                        //   onPressed: () {
                        //     showModalBottomSheet(
                        //       context: context,
                        //       shape: const RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.vertical(
                        //           top: Radius.circular(20),
                        //         ),
                        //       ),
                        //       builder: (context) => Padding(
                        //         padding: const EdgeInsets.all(15),
                        //         child: Column(
                        //           mainAxisSize: MainAxisSize.min,
                        //           crossAxisAlignment: CrossAxisAlignment.end,
                        //           children: [
                        //             Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 IconButton(
                        //                   onPressed: () {
                        //                     Get.back();
                        //                   },
                        //                   icon: const Icon(
                        //                     Icons.close,
                        //                     size: 17,
                        //                   ),
                        //                 ),
                        //                 Text(
                        //                   "راهنما",
                        //                   style: themeData
                        //                       .textTheme
                        //                       .titleMedium!
                        //                       .copyWith(
                        //                         fontWeight: FontWeight.bold,
                        //                       ),
                        //                 ),
                        //               ],
                        //             ),
                        //             const SizedBox(height: 12),
                        //             const Text(
                        //               "۱. راهنمای یک\n"
                        //               "۲. راهنمای دو\n"
                        //               "۳. راهنمای سه",
                        //               textAlign: TextAlign.start,
                        //               textDirection: TextDirection.rtl,
                        //             ),
                        //             const SizedBox(height: 16),
                        //             SizedBox(
                        //               width: double.infinity,
                        //               child: ElevatedButton(
                        //                 style: ButtonStyle(
                        //                   backgroundColor:
                        //                       WidgetStatePropertyAll(
                        //                         themeData.colorScheme.primary,
                        //                       ),
                        //                 ),
                        //                 onPressed: () => Navigator.pop(context),
                        //                 child: Text(
                        //                   "تایید",
                        //                   style: TextStyle(
                        //                     color:
                        //                         themeData.colorScheme.onPrimary,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   icon: Text(
                        //     "راهنما",
                        //     style: TextStyle(
                        //       color: themeData.colorScheme.onPrimary,
                        //     ),
                        //   ),
                        //   label: Icon(
                        //     LucideIcons.circle_question_mark,
                        //     size: 20,
                        //     color: themeData.colorScheme.onPrimary,
                        //   ),
                        // ),
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

class ResendCodeCircle extends StatefulWidget {
  final int seconds;
  final VoidCallback onResend;

  const ResendCodeCircle({
    super.key,
    this.seconds = 60,
    required this.onResend,
  });

  @override
  State<ResendCodeCircle> createState() => _ResendCodeCircleState();
}

class _ResendCodeCircleState extends State<ResendCodeCircle>
    with SingleTickerProviderStateMixin {
  late int _remaining;
  Timer? _timer;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    _startTimer();

    // کنترل چرخش دایره‌ی بیرونی
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  void _startTimer() {
    _remaining = widget.seconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining == 0) {
        timer.cancel();
        setState(() {});
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  void _resend() {
    widget.onResend();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1 - (_remaining / widget.seconds);

    return Center(
      child: SizedBox(
        width: 80,
        height: 80,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ✅ انیمیشن چرخشی حلقه‌ی بیرونی
            RotationTransition(
              turns: _rotationController,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, _) {
                  return CustomPaint(
                    painter: _CircleTimerPainter(
                      progress: value,
                      color1: const Color(0xFF00E5FF), // آبی فیروزه‌ای
                      color2: kPurple, // سبز نئون
                    ),
                    child: const SizedBox.expand(),
                  );
                },
              ),
            ),

            // ✅ محتوای وسط (ثابت)
            InkWell(
              onTap: _remaining == 0 ? _resend : null,
              borderRadius: BorderRadius.circular(80),
              child: Container(
                width: 68,
                height: 68,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _remaining == 0
                      ? kPurple
                      : Colors.white.withValues(alpha: 0.08),
                  boxShadow: [
                    if (_remaining == 0)
                      BoxShadow(
                        color: kPurple.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: _remaining == 0
                    ? const Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                        size: 28,
                      )
                    : Text(
                        _remaining.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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

class _CircleTimerPainter extends CustomPainter {
  final double progress;
  final Color color1;
  final Color color2;

  _CircleTimerPainter({
    required this.progress,
    required this.color1,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 6.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;

    // دایره خاکستری پس‌زمینه
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // دایره متحرک رنگی
    final gradient = SweepGradient(
      colors: [color1, color2, color1],
      stops: const [0.0, 0.6, 1.0],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    // کشیدن پس‌زمینه
    canvas.drawCircle(center, radius, bgPaint);

    // کشیدن قوس زمان
    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircleTimerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ThemeData themeData;

  const _GlassButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.themeData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: themeData.colorScheme.onPrimary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: themeData.colorScheme.onPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
