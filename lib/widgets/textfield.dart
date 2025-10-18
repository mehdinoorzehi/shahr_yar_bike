import 'dart:async';
import 'package:flutter/material.dart';

class MyTextFeild extends StatefulWidget {
  final TextAlign textAlign;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextDirection? hintTextDirection;
  final Function(String)? onChanged;
  final TextDirection? textDirection;
  final String? labelText;
  final TextEditingController? controller;
  final bool readOnly;
  final bool enableValidation;
  final String? Function(String value)? validator;

  const MyTextFeild({
    super.key,
    this.textAlign = TextAlign.start,
    this.textDirection = TextDirection.rtl,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.keyboardType,
    this.hintTextDirection,
    this.onChanged,
    this.labelText,
    this.controller,
    this.readOnly = false,
    this.enableValidation = false,
    this.validator,
  });

  @override
  State<MyTextFeild> createState() => _MyTextFeildState();
}

class _MyTextFeildState extends State<MyTextFeild>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;
  final ValueNotifier<Color> _borderColor = ValueNotifier(Colors.transparent);

  // اگر کاربر controller نفرستاده باشه، internal controller می‌سازیم
  TextEditingController? _internalController;
  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController!;

  bool isValid = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _internalController = TextEditingController();
    }

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _shakeAnimation =
        TweenSequence([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -10.0, end: 6.0), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 6.0, end: -4.0), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -4.0, end: 0.0), weight: 1),
        ]).animate(
          CurvedAnimation(
            parent: _shakeController,
            curve: Curves.easeInOutCubic,
          ),
        );

    // listener روی controller: قابل‌اطمینان‌تر برای IME & fast typing
    _effectiveController.addListener(_controllerListener);
  }

  void _controllerListener() {
    final textValue = _effectiveController.text;

    // اگر در حالت composing هستیم، ولیدیت رو به تعویق بنداز
    final composing = _effectiveController.value.composing;
    if (!composing.isCollapsed) {
      // هنوز در حال ترکیب هستیم؛ صبر کن
      return;
    }

    // cancel قبلی
    _debounce?.cancel();

    // اجرای سریع ولی در microtask تا از هر race condition جلوگیری شود
    // اگر طول دقیقا 11 شد، فوراً ولیدیت کن
    if (textValue.length == 11) {
      Future.microtask(() {
        if (!mounted) return;
        _validate(textValue);
      });
      return;
    }

    // در غیر این صورت با debounce کوتاه ولیدیت کن
    _debounce = Timer(const Duration(milliseconds: 1700), () {
      if (!mounted) return;
      _validate(textValue);
    });
  }

  // همچنان onChanged را صدا می‌زنیم تا API بیرونی حفظ شود
  void _onTextChanged(String value) {
    widget.onChanged?.call(value);
    // (نیازی به cancel دوباره اینجا نیست چون listener کنترل می‌کند)
  }

  void _validate(String value) {
    if (!widget.enableValidation) return;

    final validator = widget.validator ?? _defaultValidator;
    final result = validator(value);
    final valid = (result ?? '').isEmpty;

    if (valid != isValid) {
      setState(() {
        isValid = valid;
        _borderColor.value = valid
            ? Colors.greenAccent.shade400
            : Colors.redAccent;

        if (!valid) {
          _shakeController.forward(from: 0);
        }
      });
    } else {
      // حتی اگر تغییر نداشته باشه، رنگ مرز ممکنه روی حالت اشتباه مونده باشه
      _borderColor.value = valid
          ? Colors.greenAccent.shade400
          : Colors.transparent;
    }
  }

  String? Function(String value) get _defaultValidator =>
      (value) => RegExp(r'^09\d{9}$').hasMatch(value)
      ? null
      : 'شماره موبایل نامعتبر است';

  @override
  void dispose() {
    _debounce?.cancel();
    _shakeController.dispose();
    _borderColor.dispose();
    // حذف listener و dispose کردن internal controller در صورت وجود
    try {
      _effectiveController.removeListener(_controllerListener);
    } catch (_) {}
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: ValueListenableBuilder<Color>(
            valueListenable: _borderColor,
            builder: (context, borderColor, _) {
              final hasBorder = borderColor != Colors.transparent;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: hasBorder
                      ? [
                          BoxShadow(
                            color: borderColor.withValues(alpha: 0.45),
                            blurRadius: 8,
                            spreadRadius: 1.5,
                          ),
                        ]
                      : [],
                ),
                child: TextField(
                  readOnly: widget.readOnly,
                  controller: _effectiveController,
                  autocorrect: true,
                  keyboardType: widget.keyboardType,
                  maxLength: widget.maxLength,
                  textAlign: widget.textAlign,
                  textDirection: widget.textDirection,
                  onChanged: _onTextChanged,
                  style: TextStyle(
                    fontFamily: '',
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                  decoration: InputDecoration(
                    label: widget.labelText != null
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              widget.labelText!,
                              style: TextStyle(
                                fontFamily: '',
                                color: theme.colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : null,
                    hintTextDirection: widget.hintTextDirection,
                    hintText: widget.hintText,
                    filled: true,
                    fillColor: theme.colorScheme.secondary.withValues(
                      alpha: 0.03,
                    ),
                    hintStyle: TextStyle(
                      fontFamily: '',
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.5),
                    ),
                    suffixIcon: widget.prefixIcon,
                    counterText: '',
                    prefixIcon: widget.suffixIcon,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: hasBorder
                            ? borderColor
                            : theme.colorScheme.onPrimary.withValues(
                                alpha: 0.3,
                              ),
                        width: 1.6,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: hasBorder
                            ? borderColor
                            : theme.colorScheme.primary,
                        width: 2.2,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
