import 'package:bike/theme/app_colors.dart';
import 'package:bike/theme/mange_theme.dart';
import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  // 🌞 تم‌های روشن
  static final Map<ThemeType, ThemeData> lightThemes = {
    ThemeType.purpleBlue: _buildTheme(
      primary: kPurple, // بنفش
      secondary: kBlue, // آبی
      brightness: Brightness.light,
    ),
    ThemeType.greenYellow: _buildTheme(
      primary: kGreen, // سبز
      secondary: kyellow, // زرد
      brightness: Brightness.light,
    ),
    ThemeType.redOrange: _buildTheme(
      primary: kRed, // قرمز
      secondary: kOrange, // نارنجی
      brightness: Brightness.light,
    ),
    ThemeType.tealPink: _buildTheme(
      primary: kTeal, // فیروزه‌ای
      secondary: kPink, // صورتی
      brightness: Brightness.light,
    ),
  };

  // 🌙 تم‌های تاریک
  static final Map<ThemeType, ThemeData> darkThemes = {
    ThemeType.purpleBlue: _buildTheme(
      primary: const Color(0xFF2DAFE6),
      secondary: const Color(0xFF62358A),
      brightness: Brightness.dark,
    ),
    ThemeType.greenYellow: _buildTheme(
      primary: const Color(0xFFF5D100),
      secondary: const Color(0xFF50CC7F),
      brightness: Brightness.dark,
    ),
    ThemeType.redOrange: _buildTheme(
      primary: const Color(0xFFFFA726),
      secondary: const Color(0xFFE53935),
      brightness: Brightness.dark,
    ),
    ThemeType.tealPink: _buildTheme(
      primary: const Color(0xFFD81B60),
      secondary: const Color(0xFF00897B),
      brightness: Brightness.dark,
    ),
  };

  // 🎨 سازنده‌ی مشترک برای همه تم‌ها
  static ThemeData _buildTheme({
    required Color primary,
    required Color secondary,
    required Brightness brightness,
  }) {
    final bool isLight = brightness == Brightness.light;

    return ThemeData(
      fontFamily: 'vazir',
      brightness: brightness,
      scaffoldBackgroundColor: isLight ? Colors.white : const Color(0xFF121212),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        brightness: brightness,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          fontFamily: 'vazir',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: secondary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? const Color(0xFFF8F6F6) : const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: secondary, width: 1.0),
        ),
      ),
    );
  }
}
