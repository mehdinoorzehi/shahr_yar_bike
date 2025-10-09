
import 'package:flutter/material.dart';

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}

Color saturate(Color color, [double amount = .2]) {
  assert(amount >= 0 && amount <= 1);
  final hsl = HSLColor.fromColor(color);
  final hslSat = hsl.withSaturation((hsl.saturation + amount).clamp(0.0, 1.0));
  return hslSat.toColor();
}
