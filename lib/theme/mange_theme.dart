// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ThemeProvider with ChangeNotifier {
//   static const String _themeKey = 'themeMode';
//   ThemeMode _themeMode = ThemeMode.light; // 🔥 پیش‌فرض لایت

//   ThemeMode get themeMode => _themeMode;

//   ThemeProvider() {
//     _loadThemeFromPrefs();
//   }

//   void setThemeMode(ThemeMode mode) {
//     _themeMode = mode;
//     _saveThemeToPrefs(mode);
//     notifyListeners();
//   }

//   Future<void> _saveThemeToPrefs(ThemeMode mode) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_themeKey, mode.toString());
//   }

//   Future<void> _loadThemeFromPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     final saved = prefs.getString(_themeKey);

//     switch (saved) {
//       case 'ThemeMode.dark':
//         _themeMode = ThemeMode.dark;
//         break;
//       case 'ThemeMode.light':
//         _themeMode = ThemeMode.light;
//         break;
//       case 'ThemeMode.system':
//         _themeMode = ThemeMode.system;
//         break;
//       default:
//         _themeMode = ThemeMode.light; // 🔥 اگر چیزی ذخیره نشده باشه → لایت
//     }
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType {
  purpleBlue, // تم اصلی
  greenYellow, // تم شاد
  redOrange, // تم هیجانی
  tealPink, // تم مدرن
}

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'themeType';
  ThemeType _themeType = ThemeType.purpleBlue;

  ThemeType get themeType => _themeType;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  void setThemeType(ThemeType type) {
    _themeType = type;
    _saveThemeToPrefs(type);
    notifyListeners();
  }

  Future<void> _saveThemeToPrefs(ThemeType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, type.toString());
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_themeKey);

    if (saved != null) {
      _themeType = ThemeType.values.firstWhere(
        (e) => e.toString() == saved,
        orElse: () => ThemeType.purpleBlue,
      );
    }
    notifyListeners();
  }
}
