import 'package:bike/api/api_service.dart';
import 'package:bike/app_routes.dart';
import 'package:bike/widgets/toast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthenticationController extends GetxController {
  // -------------------- 🧩 متغیرها --------------------
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final RxBool isLoadingLogin = false.obs;
  final RxBool isLoadingOtp = false.obs;
  final RxString message = ''.obs;

  final RxString userCode = ''.obs;
  final RxString providerNumber = ''.obs;
  final RxString token = ''.obs;

  final RxString selectedMethod = ''.obs;

final RxInt remainingTime = 120.obs; // مقدار پیش‌فرض

  

  // -------------------- 🚀 /auth/request --------------------
  Future<void> requestVerification() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty || phone.length < 10) {
      showWarningToast(description: 'شماره موبایل نامعتبر است');
      return;
    }

    if (selectedMethod.value.isEmpty) {
      showWarningToast(description: 'روش تأیید را انتخاب کنید');
      return;
    }

    isLoadingLogin.value = true; // شروع لودینگ

    try {
      final body = {
        "identifier": phone,
        "identifier_type": "mobile",
        "verification_method": selectedMethod.value,
      };

      final response = await ApiService.post("/auth/request", body);

      if (response == null) return;

      if (response.containsKey('verification_method')) {
        message.value = response['message'] ?? '';
        userCode.value = response['user_code']?.toString() ?? '';
        providerNumber.value = response['provider_number']?.toString() ?? '';
        remainingTime.value = response['remaining_time'] ?? 120;

        //Navigate
        Future.microtask(() {
          if (Get.currentRoute != AppRoutes.otp) {
            Get.toNamed(AppRoutes.otp);
          }
        });
      } else {
        showErrorToast(description: response['message'] ?? 'خطایی رخ داده است');
      }
    } catch (e) {
      showErrorToast(description: 'خطا در برقراری ارتباط با سرور');
    } finally {
      isLoadingLogin.value = false; // ✅ در هر حالتی بسته می‌شود
    }
  }

  // -------------------- 🔐 /auth/verify --------------------
  Future<void> verifyCode() async {
    final phone = phoneController.text.trim();
    final code = otpController.text.trim();

    if (phone.isEmpty || phone.length < 10) {
      showWarningToast(description: 'شماره موبایل نامعتبر است');
      return;
    }

    if (code.isEmpty) {
      showWarningToast(description: 'کد را وارد کنید');
      return;
    }

    isLoadingOtp.value = true; // شروع لودینگ

    try {
      final body = {
        "identifier": phone,
        "identifier_type": "mobile",
        "verification_method": selectedMethod.value,
        "user_code": code,
      };

      final response = await ApiService.post("/auth/verify", body);

      if (response == null) return;

      if (response['status'] == 200 || response['token'] != null) {
        token.value = response['token'];
        Get.offAllNamed('/home');
      } else {
        // final errMsg = response['message'] ?? 'کد واردشده اشتباه است';
        // showErrorToast(description: errMsg);
      }
    } catch (e) {
      // showErrorToast(description: 'خطا در برقراری ارتباط با سرور');
    } finally {
      isLoadingOtp.value = false; // ✅ در هر حالتی بسته می‌شود
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
