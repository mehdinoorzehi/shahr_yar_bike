import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  const MyButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.isFocus = true,
  });

  final String buttonText;
  final VoidCallback onTap;
  final bool isFocus;

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // طیف گرادیان جذاب‌تر با سه رنگ و زاویه مورب
    final List<Color> activeGradient = <Color>[
      theme.colorScheme.primary,
      Color.lerp(theme.colorScheme.primary, theme.colorScheme.secondary, 0.5)!,
      theme.colorScheme.secondary,
    ];

    final List<double> stops = const [0.0, 0.55, 1.0];

    final BorderRadius radius = BorderRadius.circular(27);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.985 : (_isHovered ? 1.015 : 1.0),
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: 300,
          height: 63,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: widget.isFocus
                ? LinearGradient(
                    colors: activeGradient,
                    stops: stops,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.isFocus ? null : theme.colorScheme.tertiaryContainer,
            // boxShadow: [
            //   // سایه محیطی نرم
            //   BoxShadow(
            //     color: Colors.black.withValues(alpha:0.10),
            //     blurRadius: currentElevation,
            //     spreadRadius: 1,
            //     offset: const Offset(0, 6),
            //   ),
            //   // درخشش ظریف رنگ اول گرادیان برای حس عمق
            //   BoxShadow(
            //     color: activeGradient.first.withValues(alpha:
            //       widget.isFocus ? 0.25 : 0.0,
            //     ),
            //     blurRadius: _isHovered ? 28 : 18,
            //     spreadRadius: 0,
            //     offset: const Offset(0, 10),
            //   ),
            // ],
            border: Border.all(
              color: widget.isFocus
                  ? Colors.white.withValues(alpha: 0.18)
                  : theme.dividerColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: radius,
              onTap: widget.onTap,
              onHighlightChanged: (v) => setState(() => _isPressed = v),
              splashColor: Colors.white.withValues(alpha: 0.08),
              highlightColor: Colors.white.withValues(alpha: 0.10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // هایلایت لطیف بالا برای حس شیشه‌ای
                  if (widget.isFocus)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 63 * 0.42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: radius.topLeft,
                            topRight: radius.topRight,
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.22),
                              Colors.white.withValues(alpha: 0.04),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Center(
                    child: Text(
                      widget.buttonText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        color: widget.isFocus
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.primary,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
