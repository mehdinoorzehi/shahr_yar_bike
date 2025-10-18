import 'dart:ui';
import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  const MyButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.isFocus = false,
    this.isLoading = false, // 🔹 اضافه شد
  });

  final String buttonText;
  final VoidCallback onTap;
  final bool isFocus;
  final bool isLoading; // 🔹 اضافه شد

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final BorderRadius radius = BorderRadius.circular(32);

    final List<Color> activeGradient = <Color>[
      theme.colorScheme.primary,
      Color.lerp(theme.colorScheme.primary, theme.colorScheme.secondary, 0.5)!,
      theme.colorScheme.secondary,
    ];
    const List<double> stops = [0.0, 0.55, 1.0];

    return ClipRRect(
      borderRadius: radius,
      child: Stack(
        children: [
          // 🔹 پس‌زمینه فوکوس یا گرادیان
          if (widget.isFocus)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: radius,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.35),
                      Colors.white.withValues(alpha: 0.25),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      offset: const Offset(0, 8),
                      blurRadius: 32,
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              width: 300,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: LinearGradient(
                  colors: activeGradient,
                  stops: stops,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

          // 🔹 محتوای دکمه (متن یا لودینگ)
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: radius,
                onTap: widget.isLoading
                    ? null
                    : widget.onTap, // 🔹 غیرفعال هنگام لودینگ
                splashColor: Colors.white.withValues(alpha: 0.08),
                highlightColor: Colors.white.withValues(alpha: 0.10),
                child: Center(
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          widget.buttonText,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            shadows: [
                              Shadow(
                                color: Colors.white.withValues(alpha: 0.8),
                                blurRadius: 10,
                                offset: const Offset(0, 0),
                              ),
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 4,
                                offset: const Offset(1, 2),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
