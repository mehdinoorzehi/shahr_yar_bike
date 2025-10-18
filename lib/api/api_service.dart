import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bike/helper/go_to_check_screen.dart';
import 'package:bike/helper/location_helper.dart';
import 'package:bike/langs/translation_service.dart';
import 'package:bike/widgets/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:get/get.dart';

class ApiService {
  static const String baseUrl = 'https://bike.sirjan.ir/demo/api';

  // 📦 ساخت هدرها
  static Future<Map<String, String>> _buildHeaders() async {
    String appVersion = 'unknown';
    try {
      final info = await PackageInfo.fromPlatform();
      appVersion = info.version;
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ خطا در دریافت نسخه اپ: $e');
      }
    }

    String locale = 'fa';
    try {
      locale = Get.find<TranslationService>().currentLocale.value.languageCode;
    } catch (_) {}

    String location = '';
    try {
      final pos = await safeGetCurrentPosition();
      if (pos != null) {
        location = '${pos.latitude},${pos.longitude}';
      }
    } catch (_) {}

    final headers = {
      'Content-Type': 'application/json',
      'APP_VERSION': appVersion,
      'LOCALE': locale,
      'LOCATION': location,
    };

    if (kDebugMode) {
      print('📤 [HEADERS] →');
    }
    // ignore: avoid_print
    headers.forEach((k, v) => print('   $k: $v'));

    return headers;
  }

  // 🔹 POST
  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    if (kDebugMode) {
      print('🟦 [POST] → $baseUrl$endpoint');
    }
    if (kDebugMode) {
      print('📦 Body: $body');
    }
    try {
      final headers = await _buildHeaders();
      final response = await http
          .post(
            Uri.parse(baseUrl + endpoint),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      if (kDebugMode) {
        print('🟩 [POST] Response: ${response.statusCode}');
      }
      return handleResponse(response);
    } on SocketException {
      showErrorToast(description: 'اتصال به اینترنت برقرار نیست');
      return null;
    } on TimeoutException {
      showWarningToast(description: 'درخواست شما منقضی شد');
      return null;
    } catch (e) {
      showErrorToast(description: 'خطا در ارسال داده');
      return null;
    }
  }

  // 🔹 PUT
  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    if (kDebugMode) {
      print('🟦 [PUT] → $baseUrl$endpoint');
    }
    if (kDebugMode) {
      print('📦 Body: $body');
    }
    try {
      final headers = await _buildHeaders();
      final response = await http
          .put(
            Uri.parse(baseUrl + endpoint),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      if (kDebugMode) {
        print('🟩 [PUT] Response: ${response.statusCode}');
      }
      return handleResponse(response);
    } on SocketException {
      showErrorToast(description: 'اتصال به اینترنت برقرار نیست');
      return null;
    } on TimeoutException {
      showWarningToast(description: 'درخواست شما منقضی شد');
      return null;
    } catch (e) {
      showErrorToast(description: 'خطا در به‌روزرسانی داده');
      return null;
    }
  }

  // 🔹 DELETE
  static Future<dynamic> delete(String endpoint) async {
    if (kDebugMode) {
      print('🟦 [DELETE] → $baseUrl$endpoint');
    }
    try {
      final headers = await _buildHeaders();
      final response = await http
          .delete(Uri.parse(baseUrl + endpoint), headers: headers)
          .timeout(const Duration(seconds: 15));

      if (kDebugMode) {
        print('🟩 [DELETE] Response: ${response.statusCode}');
      }
      return handleResponse(response);
    } on SocketException {
      showErrorToast(description: 'اتصال به اینترنت برقرار نیست');
      return null;
    } on TimeoutException {
      showWarningToast(description: 'درخواست شما منقضی شد');
      return null;
    } catch (e) {
      showErrorToast(description: 'خطا در حذف داده');
      return null;
    }
  }

  // 🔹 GET
  static Future<dynamic> get(String endpoint) async {
    if (kDebugMode) {
      print('🟦 [GET] → $baseUrl$endpoint');
    }
    try {
      final headers = await _buildHeaders();
      final response = await http
          .get(Uri.parse(baseUrl + endpoint), headers: headers)
          .timeout(const Duration(seconds: 15));

      if (kDebugMode) {
        print('🟩 [GET] Response: ${response.body.toString()}');
      }
      return handleResponse(response);
    } on SocketException {
      showErrorToast(description: 'اتصال اینترنت برقرار نیست');
      return null;
    } on TimeoutException {
      showWarningToast(description: 'درخواست منقضی شد');
      return null;
    } on HttpException {
      showErrorToast(description: 'پاسخ نامعتبر از سرور');
      return null;
    } on FormatException {
      showErrorToast(description: 'فرمت پاسخ اشتباه است');
      return null;
    } catch (e) {
      showErrorToast(description: 'خطا در دریافت داده ها');
      return null;
    }
  }

  // 🎯 بررسی پاسخ سرور
  static dynamic handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    dynamic body;

    try {
      body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
    } catch (e) {
      body = {'message': 'پاسخ نامعتبر از سرور'};
    }

    final message = body['message']?.toString().tr ?? '';

    switch (statusCode) {
      case 200:
      case 201:
        body['ok'] = true; // ✅ اضافه برای تشخیص موفقیت
        break;
      case 400:
        showWarningToast(
          description: message.isNotEmpty ? message : 'درخواست نامعتبر',
        );
        break;
      case 401:
        showErrorToast(
          description: message.isNotEmpty ? message : 'دسترسی غیرمجاز',
        );
        break;
      case 403:
        showErrorToast(
          description: message.isNotEmpty ? message : 'اجازه دسترسی ندارید',
        );
        break;
      case 404:
        showWarningToast(
          description: message.isNotEmpty ? message : 'موردی یافت نشد',
        );
        break;
      case 500:
      case 502:
      case 503:
      case 504:
        goToCheckScreen();
        break;
      default:
        showWarningToast(description: 'خطای ناشناخته');
        break;
    }

    return body;
  }
}
