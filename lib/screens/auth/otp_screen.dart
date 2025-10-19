import 'dart:async';
import 'package:bike/app_routes.dart';
import 'package:bike/controllers/authentication_controller.dart';
import 'package:bike/theme/app_colors.dart';
import 'package:bike/widgets/animated_background.dart';
import 'package:bike/widgets/button.dart';
import 'package:bike/widgets/textfield.dart';
import 'package:bike/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:bike/extensions/translation_extension.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authController = Get.find<AuthenticationController>();

    // 🔹 بررسی: اگر شماره پاک شده (مثلاً بعد از refresh)
    if (authController.phoneController.text.isEmpty) {
      return Scaffold(
        body: SafeArea(
          child: AnimatedBackground(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.amber,
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'برای ادامه، لطفاً دوباره وارد شوید',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    buttonText: 'بازگشت به ورود',
                    onTap: () => Get.toNamed(AppRoutes.login),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // 🔹 حالت خاص: نمایش کد برای ارسال توسط کاربر
    if (authController.selectedMethod.value == 'sms_from_user') {
      return Scaffold(
        body: SafeArea(
          child: AnimatedBackground(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      LucideIcons.smartphone,
                      color: Colors.white,
                      size: 80,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'verification_code_display'.trNamed({
                        'provider_number': authController.providerNumber.value,
                      }),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      authController.userCode.value,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "after_sending_code_press_check".tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      isFocus: true,
                      buttonText: "check".tr,
                      onTap: () => Get.offAllNamed(AppRoutes.home),
                    ),
                    const SizedBox(height: 60),
                    _buildTipsSection(theme),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // 🔹 حالت عادی (OTP Code Input)
    return Scaffold(
      body: SafeArea(
        child: AnimatedBackground(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  // 🔹 عنوان صفحه
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'sms_code'.tr,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // 🔹 محتوای اصلی (قابل اسکرول)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 1.2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 36, 28, 20),
                        child: Column(
                          children: [
                            // 🔹 بخش اسکرول‌پذیر بالای فرم
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Center(
                                      child: Text(
                                        'verification_code_sent'.trNamed({
                                          'number': authController
                                              .phoneController
                                              .text,
                                        }),
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.titleSmall
                                            ?.apply(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                              fontSizeFactor: 1.1,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),

                                    // 🔹 فیلد کد
                                    Center(
                                      child: SizedBox(
                                        width: 200,
                                        child: MyTextFeild(
                                          controller:
                                              authController.otpController,
                                          maxLength: 6,
                                          textDirection: TextDirection.ltr,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 35),

                                    // 🔹 دکمه‌های ویرایش و ارسال مجدد
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        _GlassButton(
                                          icon: LucideIcons.pencil,
                                          label: "edit_number".tr,
                                          onTap: () => Get.back(),
                                          themeData: theme,
                                        ),
                                        Obx(
                                          () => ResendCodeButton(
                                            seconds: authController
                                                .remainingTime
                                                .value,
                                            onResend: () async {
                                              showWarningToast(
                                                description:
                                                    'شماره موبایل وارد شده نادرست است',
                                              );
                                              await authController
                                                  .requestVerification();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 60),

                                    // 🔹 دکمه ادامه
                                    Obx(
                                      () => MyButton(
                                        isLoading:
                                            authController.isLoadingOtp.value,
                                        isFocus: true,
                                        buttonText: 'continue_btn'.tr,
                                        onTap: () async {
                                          await authController.verifyCode();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // 🔹 نکات پایین (ثابت مثل لاگین)
                            _buildTipsSection(theme),
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
      ),
    );
  }

  Widget _buildTipsSection(ThemeData theme) {
    final tips = _buildOtpTips(theme);
    return Column(
      children: [
        Divider(color: theme.colorScheme.onPrimary.withValues(alpha: 0.3)),
        const SizedBox(height: 16),
        ...tips,
      ],
    );
  }
}

Widget buildTip(String text, ThemeData themeData) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          LucideIcons.circle_check,
          color: themeData.colorScheme.onPrimary.withValues(alpha: 0.8),
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            // textDirection: TextDirection.rtl,
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: themeData.colorScheme.onPrimary.withValues(alpha: 0.8),
              height: 1.5,
              fontSize: 13.5,
            ),
          ),
        ),
      ],
    ),
  );
}

// List<Widget> _buildOtpTips(ThemeData themeData) {
//   final tips = <Widget>[];
//   int index = 1;
//   while (true) {
//     final key = 'otp_help_$index';
//     final text = key.tr;
//     if (text.isEmpty || text == key) break;
//     tips.add(buildTip(text, themeData));
//     index++;
//   }
//   return tips;
// }

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
            child: Row(
              key: const ValueKey('content'),
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
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
      bool success = false;

      try {
        await widget.onResend();
        success = true; // فقط وقتی بدون خطا انجام شد
      } catch (e) {
        success = false;
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }

      if (success) {
        _remaining = widget.seconds;
        _startTimer();
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
                    Colors.white.withValues(alpha: 0.15),
                    Colors.white.withValues(alpha: 0.05),
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
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
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
