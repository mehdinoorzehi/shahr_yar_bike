// translation_extension.dart
import 'package:get/get.dart';

extension TrNamedArgs on String {
  /// ترجمه با جایگذاری پارامترهای نام‌دار مثل :number, :seconds
  /// مثال استفاده:
  /// 'verification_code_sent'.trNamed({'number': '09121234567'})
  String trNamed([Map<String, dynamic>? params]) {
    var translated = tr;

    if (params == null || params.isEmpty) return translated;

    params.forEach((key, value) {
      translated = translated.replaceAll(':$key', value.toString());
      translated = translated.replaceAll('(:$key)', '(${value.toString()})');
    });

    return translated;
  }
}
