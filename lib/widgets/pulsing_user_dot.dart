
import 'package:flutter/material.dart';

/// -----------------------
/// PulsingUserDot - safe self-contained animation widget
/// -----------------------
class PulsingUserDot extends StatefulWidget {
  const PulsingUserDot({super.key});
  @override
  State<PulsingUserDot> createState() => _PulsingUserDotState();
}

class _PulsingUserDotState extends State<PulsingUserDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween(
      begin: 0.7,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.stop();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return ScaleTransition(
      scale: _anim,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _theme.colorScheme.secondary.withValues(alpha: 0.6),
        ),
        child: Center(
          child: Container(
            width: 10,
            height: 10,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color: _theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
