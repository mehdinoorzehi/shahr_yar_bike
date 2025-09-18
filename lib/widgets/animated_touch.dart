import 'package:flutter/material.dart';

class AnimatedTouch extends StatefulWidget {
  const AnimatedTouch({
    super.key,
    required this.child,
    this.onTap,
    this.scaleOnHover = 1.02,
    this.scaleOnPress = 0.98,
    this.duration = const Duration(milliseconds: 140),
    this.curve = Curves.easeOut,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scaleOnHover;
  final double scaleOnPress;
  final Duration duration;
  final Curve curve;
  final BorderRadius? borderRadius;

  @override
  State<AnimatedTouch> createState() => _AnimatedTouchState();
}

class _AnimatedTouchState extends State<AnimatedTouch> {
  bool _hovered = false;
  bool _pressed = false;

  double get _scale {
    if (_pressed) return widget.scaleOnPress;
    if (_hovered) return widget.scaleOnHover;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(12);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _scale,
        duration: widget.duration,
        curve: widget.curve,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: widget.onTap,
            onHighlightChanged: (v) => setState(() => _pressed = v),
            splashColor: Colors.white.withValues(alpha: 0.06),
            highlightColor: Colors.white.withValues(alpha: 0.08),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
