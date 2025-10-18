import 'dart:async';
import 'package:bike/app_routes.dart';
import 'package:bike/controllers/authentication_controller.dart';
import 'package:bike/screens/auth/login_screen.dart';
import 'package:bike/theme/app_colors.dart';
import 'package:bike/widgets/animated_background.dart';
import 'package:bike/widgets/button.dart';
import 'package:bike/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:bike/extensions/translation_extension.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final authController = Get.find<AuthenticationController>();

    // 🟢 اگر متد از نوع sms_from_user است:
    if (authController.selectedMethod.value == 'sms_from_user') {
      return Scaffold(
        body: AnimatedBackground(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Icon(
                      LucideIcons.smartphone,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      'verification_code_display'.trNamed({
                        'provider_number': authController.providerNumber.value,
                      }),
                      style: themeData.textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      authController.userCode.value,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      "after_sending_code_press_check".tr,
                      style: themeData.textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 15),

                  MyButton(
                    isFocus: true,
                    buttonText: "check".tr,
                    onTap: () => Get.offAllNamed(AppRoutes.home),
                  ),
                  const SizedBox(height: 110),

                  // ✅ نکات پایین فرم
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [..._buildOtpTips(themeData)],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: AnimatedBackground(
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(bottom: 20, right: 40, left: 40),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Text(
                    'sms_code'.tr,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: themeData.colorScheme.onPrimary,
                      fontSize: 18,
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
                            'verification_code_sent'.trNamed({
                              'number': authController.phoneController.text,
                            }),
                            textAlign: TextAlign.center,
                            style: themeData.textTheme.titleSmall!.apply(
                              color: themeData.colorScheme.onPrimary,
                              fontSizeFactor: 1.1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: SizedBox(
                            width: 200,
                            child: MyTextFeild(
                              controller: authController.otpController,
                              maxLength: 6,
                              textDirection: TextDirection.ltr,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        // const SizedBox(height: 20),
                        // ResendCodeCircle(
                        //   seconds: 120,
                        //   onResend: () async {
                        //     await authController.requestVerification();
                        //   },
                        // ),
                        const SizedBox(height: 20),

                        // 🔹 تایمر دایره‌ای وسط
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // 🔹 دکمه ویرایش شماره
                            _GlassButton(
                              icon: LucideIcons.pencil,
                              label: "edit_number".tr,
                              onTap: () => Get.back(),
                              themeData: themeData,
                            ),

                            // 🔹 دکمه ارسال مجدد کد
                            Obx(
                              () => ResendCodeButton(
                                seconds: authController.remainingTime.value,
                                onResend: () async {
                                  await authController.requestVerification();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 80),
                        Obx(
                          () => MyButton(
                            isLoading: authController.isLoadingOtp.value,
                            isFocus: true,
                            buttonText: 'continue_btn'.tr,
                            onTap: () async {
                              await authController.verifyCode();
                            },
                          ),
                        ),

                        const SizedBox(height: 110),

                        // 🔹 دکمه راهنمای ورود موقتاً غیرفعال شد
                        // TextButton.icon(
                        //   onPressed: () { ... },
                        //   icon: Text("راهنمای ورود"),
                        //   label: Icon(LucideIcons.circle_question_mark),
                        // ),

                        // ✅ نکات پایین فرم
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [..._buildOtpTips(themeData)],
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

class _GlassButton extends StatelessWidget {
  final IconData? icon; // ✅ قابل null شدن
  final String label;
  final VoidCallback onTap;
  final ThemeData themeData;

  const _GlassButton({
    this.icon,
    required this.label,
    required this.onTap,
    required this.themeData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child:  Row(
                    key: const ValueKey('content'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null)
                        Icon(
                          icon,
                          size: 16,
                          color: themeData.colorScheme.onPrimary,
                        ),
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
        ),
      ),
    );
  }
}

List<Widget> _buildOtpTips(ThemeData themeData) {
  List<Widget> tips = [];
  int index = 1;

  while (true) {
    final key = 'login_verify_help_$index';
    final text = key.tr;

    // اگر کلید خالی یا برابر کلید خودش بود یعنی ترجمه وجود نداره → توقف
    if (text.isEmpty || text == key) break;

    tips.add(buildTip(text, themeData));
    tips.add(const SizedBox(height: 8));

    index++;
  }

  return tips;
}

class ResendCodeButton extends StatefulWidget {
  final int seconds;
  final Future<void> Function() onResend;

  const ResendCodeButton({
    super.key,
    required this.seconds,
    required this.onResend,
  });

  @override
  State<ResendCodeButton> createState() => _ResendCodeButtonState();
}

class _ResendCodeButtonState extends State<ResendCodeButton>
    with SingleTickerProviderStateMixin {
  late int _remaining;
  Timer? _timer;
  late AnimationController _gradientController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    _startTimer();

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant ResendCodeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // اگر مقدار ثانیه از کنترلر بیرونی تغییر کند
    if (oldWidget.seconds != widget.seconds) {
      _remaining = widget.seconds;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (_remaining <= 0) return;
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
    _gradientController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_remaining == 0 && !_isLoading) {
      setState(() => _isLoading = true);

      try {
        await widget.onResend();
        // وقتی درخواست موفق بود، زمان دوباره از نو شروع بشه
        _remaining = widget.seconds;
        _startTimer();
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = _remaining == 0 && !_isLoading;

    return GestureDetector(
      onTap: isActive ? _handleTap : null,
      child: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          final animationValue = _gradientController.value;
          final angle = animationValue * 2 * math.pi;

          final gradient = LinearGradient(
            colors: isActive
                ? [kPurple, kBlue]
                : [
                    Colors.white.withValues(alpha:0.15),
                    Colors.white.withValues(alpha:0.05),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            transform: GradientRotation(angle),
          );

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha:0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isActive
                            ? Icons.refresh_rounded
                            : Icons.lock_clock_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      isActive
                          ? Text(
                              "resend_code".tr,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Row(
                              children: [
                                Text(
                                  "$_remaining",
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  "senconds_until_resend".tr,
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
