import 'package:get/get.dart';

class AppTranslations extends Translations {
  static final Map<String, Map<String, String>> _localizedValues = {};

  @override
  Map<String, Map<String, String>> get keys => _localizedValues;

  static void setLocaleMap(String localeKey, Map<String, String> map) {
    _localizedValues[localeKey] = map;
  }
}
