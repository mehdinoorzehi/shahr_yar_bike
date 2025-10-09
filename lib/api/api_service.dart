import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bike/widgets/toast.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://bike.sirjan.ir/demo/api';

  /// درخواست POST
  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    print('🟦 [POST] شروع درخواست → $baseUrl$endpoint');
    print('📦 بدنه درخواست: $body');
    try {
      final response = await http
          .post(
            Uri.parse(baseUrl + endpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      print(
        '🟩 [POST] پاسخ دریافتی از سرور: '
        'status=${response.statusCode}, body=${response.body}',
      );
      return handleResponse(response);
    } catch (e) {
      showErrorToast(description: 'خطا در ارسال داده');
    }
  }

  /// درخواست PUT
  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    print('🟦 [PUT] شروع درخواست → $baseUrl$endpoint');
    print('📦 بدنه درخواست: $body');
    try {
      final response = await http
          .put(
            Uri.parse(baseUrl + endpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      print(
        '🟩 [PUT] پاسخ دریافتی از سرور: '
        'status=${response.statusCode}, body=${response.body}',
      );
      return handleResponse(response);
    } catch (e) {
      showErrorToast(description: 'خطا در به‌روزرسانی داده');
    }
  }

  /// درخواست DELETE
  static Future<dynamic> delete(String endpoint) async {
    print('🟦 [DELETE] شروع درخواست → $baseUrl$endpoint');
    try {
      final response = await http
          .delete(Uri.parse(baseUrl + endpoint))
          .timeout(const Duration(seconds: 15));

      print(
        '🟩 [DELETE] پاسخ دریافتی از سرور: '
        'status=${response.statusCode}, body=${response.body}',
      );
      return handleResponse(response);
    } catch (e) {
      showErrorToast(description: 'خطا در حذف داده');
    }
  }

  /// درخواست GET
  static Future<dynamic> get(String endpoint) async {
    print('🟦 [GET] شروع درخواست → $baseUrl$endpoint');
    try {
      final response = await http
          .get(Uri.parse(baseUrl + endpoint))
          .timeout(const Duration(seconds: 15));

      print(
        '🟩 [GET] پاسخ دریافتی از سرور: '
        'status=${response.statusCode}, body=${response.body}',
      );

      // 👇 بررسی پاسخ و بازگرداندن بدنه
      return handleResponse(response);
    } on SocketException {
      showErrorToast(description: 'عدم اتصال به اینترنت');
    } on TimeoutException {
      showWarningToast(
        description: 'درخواست شما منقضی شد، لطفاً دوباره تلاش کنید',
      );
    } on HttpException {
      showErrorToast(description: 'پاسخ نامعتبر از سرور');
    } on FormatException {
      showErrorToast(description: 'فرمت پاسخ اشتباه است');
    } catch (e) {
      showErrorToast(description: e.toString());
    }
  }

  /// بررسی پاسخ سرور
  static dynamic handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    print('📬 [ResponseHandler] status=$statusCode, body=$body');

    final serverMessage = body?['message']?.toString() ?? '';

    // 🔹 نمایش پیام در هر حالت
    switch (statusCode) {
      case 200:
      case 201:
        showSuccessToast(
          description: serverMessage.isNotEmpty
              ? serverMessage
              : 'عملیات با موفقیت انجام شد',
        );
        break;

      case 202:
      case 203:
        showInfoToast(
          description: serverMessage.isNotEmpty
              ? serverMessage
              : 'درخواست شما در حال پردازش است',
        );
        break;

      case 400:
        showWarningToast(
          description: serverMessage.isNotEmpty
              ? serverMessage
              : 'درخواست نامعتبر',
        );
        break;

      case 401:
        showErrorToast(
          description: serverMessage.isNotEmpty
              ? serverMessage
              : 'دسترسی غیرمجاز',
        );
        break;

      case 403:
        showErrorToast(
          description: serverMessage.isNotEmpty
              ? serverMessage
              : 'شما اجازه دسترسی ندارید',
        );
        break;

      case 404:
        showWarningToast(
          description: serverMessage.isNotEmpty
              ? serverMessage
              : 'موردی یافت نشد',
        );
        break;

      case 408:
        showWarningToast(
          description: serverMessage.isNotEmpty
              ? serverMessage
              : 'درخواست منقضی شد',
        );
        break;

      case 500:
      case 502:
      case 503:
      case 504:
        showErrorToast(
          description: serverMessage.isNotEmpty
              ? serverMessage
              : 'خطای سرور، لطفاً بعداً دوباره تلاش کنید',
        );
        break;

      default:
        showWarningToast(
          description: serverMessage.isNotEmpty
              ? serverMessage
              : 'خطای ناشناخته',
        );
        break;
    }

    // ✅ بدنه پاسخ را در همه حالت‌ها برگردان
    return body;
  }
}
