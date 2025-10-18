import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bike/helper/location_helper.dart';
import 'package:bike/api/api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class VerificationMethod {
  final String method;

  VerificationMethod({required this.method});

  factory VerificationMethod.fromJson(Map<String, dynamic> json) {
    return VerificationMethod(method: json['method'] ?? '');
  }
}

class InitialController extends GetxController {
  // -------------------- 🛰️ چک سرور و لوکیشن --------------------
  var serverLoading = false.obs;
  var locationLoading = false.obs;

  final Rxn<Position> currentPosition = Rxn<Position>();
  var serverOk = false.obs;
  final RxString message = ''.obs;

  // ✅ پیام خطای لوکیشن برای نمایش در کارت
  final RxString locationErrorMessage = ''.obs;

  // -------------------- 🔑 لاگین --------------------
  final RxList<VerificationMethod> methods = <VerificationMethod>[].obs;
  final Rx<VerificationMethod?> selectedMethod = Rx<VerificationMethod?>(null);
  final RxBool isLoginLoading = false.obs;

  // -------------------- 🚀 آن‌بوردینگ --------------------
  final RxInt totalPages = 0.obs;
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
    _calculateOnboardingPages(); // ✅ محاسبه خودکار صفحات آن‌بوردینگ
  }

  // -------------------- محاسبه تعداد صفحات از ترجمه‌ها --------------------
  void _calculateOnboardingPages() {
    int count = 0;
    while (true) {
      final pic = 'onboarding_pic_${count + 1}'.tr;
      final title = 'onboarding_title_${count + 1}'.tr;
      final desc = 'onboarding_desc_${count + 1}'.tr;

      if (pic.startsWith('onboarding_') &&
          title.startsWith('onboarding_') &&
          desc.startsWith('onboarding_')) {
        break;
      }
      count++;
    }

    totalPages.value = count;
    debugPrint("✅ Onboarding pages detected: $count");
  }

  // -------------------- 🧩 تجمیع بررسی‌ها --------------------
  Future<void> fetchAllData() async {
    await checkServerConnection();
    await checkLocation();
  }

  // -------------------- 🌐 بررسی اتصال سرور --------------------
  Future<void> checkServerConnection() async {
    serverLoading.value = true;
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      // ignore: unrelated_type_equality_checks
      if (connectivityResult == ConnectivityResult.none) {
        message.value = 'اتصال اینترنت خود را فعال کنید';
        serverOk.value = false;
        return;
      }

      final response = await ApiService.get('/init');
      if (response == null) {
        message.value = 'پاسخی از سرور دریافت نشد';
        serverOk.value = false;
        return;
      }

      message.value = response['message'] ?? 'پاسخی از سرور دریافت نشد';
      serverOk.value = response['ok'] == true;

      // ✅ متدهای ورود
      if (response['verification_methods'] != null) {
        final list = response['verification_methods'] as List;
        final parsed = list.map((m) => VerificationMethod.fromJson(m)).toList();
        methods.assignAll(parsed);
        if (parsed.isNotEmpty) {
          selectedMethod.value = parsed.first;
        }
      }
    } catch (e) {
      message.value = 'خطا در اتصال به سرور';
      serverOk.value = false;
      debugPrint("❌ خطا در checkServerConnection: $e");
    } finally {
      serverLoading.value = false;
    }
  }

  // -------------------- 🧭 بررسی موقعیت --------------------
  Future<void> checkLocation() async {
    locationLoading.value = true;
    locationErrorMessage.value = ''; // پاک‌سازی پیام قبلی

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locationErrorMessage.value = 'سرویس موقعیت غیرفعال است';
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        locationErrorMessage.value = 'دسترسی به موقعیت رد شده است';
        return;
      }

      final pos = await safeGetCurrentPosition();
      if (pos == null) {
        locationErrorMessage.value = 'خطا در دریافت موقعیت';
        return;
      }

      // ✅ موفقیت در گرفتن موقعیت
      currentPosition.value = pos;
      locationErrorMessage.value = ''; // پاک‌سازی پیام خطا
    } catch (e) {
      locationErrorMessage.value = 'خطا در دریافت موقعیت';
      debugPrint("❌ خطا در checkLocation: $e");
    } finally {
      locationLoading.value = false;
    }
  }

  // -------------------- 📄 کنترل آن‌بوردینگ --------------------
  void setCurrentPage(int index) => currentPage.value = index;

  Future<void> nextPage(VoidCallback onFinished) async {
    if (currentPage.value < totalPages.value - 1) {
      await pageController.animateToPage(
        currentPage.value + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      onFinished();
    }
  }

  String getOnboardingImagePath(int index) {
    final translated = 'onboarding_pic_${index + 1}'.tr;
    if (translated.isEmpty || translated.startsWith('onboarding_')) return '';
    return translated;
  }

  bool isNetworkImage(int index) {
    final translated = 'onboarding_pic_${index + 1}'.tr;
    return translated.startsWith('http');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
