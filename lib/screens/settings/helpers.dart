import 'package:bike/theme/app_colors.dart';
import 'package:bike/theme/mange_theme.dart';
import 'package:flutter/material.dart';

List<Color> getThemeColors(ThemeType theme) {
  switch (theme) {
    case ThemeType.purpleBlue:
      return [kPurple, kBlue];
    case ThemeType.greenYellow:
      return [kGreen, kyellow];
    case ThemeType.redOrange:
      return [kRed, kOrange];
    case ThemeType.tealPink:
      return [kTeal, kPink];
  }
}

String getThemeTitle(ThemeType theme) {
  switch (theme) {
    case ThemeType.purpleBlue:
      return "شهریار";
    case ThemeType.greenYellow:
      return "بهار سبز";
    case ThemeType.redOrange:
      return "غروب آتشین";
    case ThemeType.tealPink:
      return "رویای دریا";
  }
}
