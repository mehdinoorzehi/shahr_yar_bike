import 'package:flutter/material.dart';

class MyTextFeild extends StatelessWidget {
  final TextAlign textAlign;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffoxIcon;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextDirection? hintTextDirection;
  final Function(String)? onChanged;
  final TextDirection? textDirection;
  final String? labelText;
  final TextEditingController? controller;
  final bool readOnly;

  const MyTextFeild({
    super.key,
    this.textAlign = TextAlign.start,
    this.textDirection = TextDirection.rtl,
    this.hintText,
    this.prefixIcon,
    this.suffoxIcon,
    this.maxLength,
    this.keyboardType,
    this.hintTextDirection,
    this.onChanged,
    this.labelText,
    this.controller,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      controller: controller,
      autocorrect: true,
      keyboardType: keyboardType,
      onChanged: onChanged,
      maxLength: maxLength,
      textAlign: textAlign,
      textDirection: textDirection,
      style: const TextStyle(fontFamily: '', fontSize: 18),
      decoration: InputDecoration(
        // labelText: labelText,
        label: labelText != null
            ? Align(
                alignment: Alignment.centerRight, // راست‌چین
                child: Text(
                  labelText!,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
        hintTextDirection: hintTextDirection,
        hintText: hintText,
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.secondary.withValues(alpha: 0.03),
        hintStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
        ),
        suffixIcon: suffoxIcon,
        counterText: '',
        prefixIcon: prefixIcon,
        prefixIconColor: Theme.of(context).colorScheme.primary,
        suffixIconColor: Theme.of(context).colorScheme.primary,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          ), // رنگ حالت عادی
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ), // رنگ زمان فوکوس (مثلاً قرمز)
        ),
      ),
    );
  }
}
