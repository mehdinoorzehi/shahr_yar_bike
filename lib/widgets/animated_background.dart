import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Stack(
          children: [
            // 🎨 پس‌زمینه‌ی مایع متحرک
            Positioned.fill(
              child: CustomPaint(
                painter: _LiquidGradientPainter(
                  animationValue: _controller.value,
                  color1: scheme.primary,
                  color2: scheme.secondary,
                ),
              ),
            ),
            // ✨ نرمی و عمق (افکت بلور)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 55, sigmaY: 55),
                child: Container(color: scheme.primary.withOpacity(0.8)),
              ),
            ),
            // 🎨 پس‌زمینه‌ی مایع متحرک
            Positioned.fill(
              child: CustomPaint(
                painter: _LiquidGradientPainter(
                  animationValue: _controller.value,
                  color1: scheme.primary,
                  color2: scheme.secondary,
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      scheme.primary.withOpacity(0.15),
                      scheme.secondary.withOpacity(0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // محتوای اصلی
            Positioned.fill(child: widget.child),
          ],
        );
      },
    );
  }
}

class _LiquidGradientPainter extends CustomPainter {
  final double animationValue;
  final Color color1;
  final Color color2;

  _LiquidGradientPainter({
    required this.animationValue,
    required this.color1,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // سه لکه متحرک که رنگ‌ها را ترکیب می‌کنند
    final blobs = [
      Offset(
        size.width * (0.5 + 0.4 * sin(animationValue * 2 * pi)),
        size.height * (0.4 + 0.3 * cos(animationValue * 2 * pi)),
      ),
      Offset(
        size.width * (0.3 + 0.5 * cos(animationValue * 2 * pi)),
        size.height * (0.6 + 0.4 * sin(animationValue * 3 * pi)),
      ),
      Offset(
        size.width * (0.7 + 0.2 * sin(animationValue * 4 * pi)),
        size.height * (0.5 + 0.3 * cos(animationValue * 3 * pi)),
      ),
    ];

    final colors = [color1, color2];

    for (int i = 0; i < blobs.length; i++) {
      final gradient = RadialGradient(
        colors: [
          colors[i % 2].withOpacity(0.7),
          colors[(i + 1) % 2].withOpacity(0.0),
        ],
      );

      paint.shader = gradient.createShader(
        Rect.fromCircle(center: blobs[i], radius: size.width * 0.8),
      );

      canvas.drawCircle(blobs[i], size.width * 0.8, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _LiquidGradientPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
