import 'package:bike/helper/color_extention.dart';
import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class AnimatedBackground extends StatelessWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final colors = [
      saturate(darken(scheme.primary, 0.10), 0.20),
      saturate(darken(scheme.secondary, 0.10), 0.20),
      saturate(darken(scheme.primary, 0.10), 0.20),
      saturate(darken(scheme.secondary, 0.10), 0.20),
    ];

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedMeshGradient(
            colors: colors,
            options: AnimatedMeshGradientOptions(
              speed: 4,
          
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}
