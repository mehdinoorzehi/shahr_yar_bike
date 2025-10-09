import 'package:bike/api/api_service.dart';
import 'package:bike/widgets/toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../app_routes.dart';

class CheckAccessController extends GetxController {
  var serverLoading = false.obs;
  var locationLoading = false.obs;
  final Rxn<Position> currentPosition = Rxn<Position>();
  var serverOk = false.obs;
  final RxString message = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkServerConnection(auto: true);
    checkLocation();
  }

  Future<void> checkServerConnection({bool auto = false}) async {
    serverLoading.value = true;
    serverOk.value = false;
    message.value = '';

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      // ignore: unrelated_type_equality_checks
      if (connectivityResult == ConnectivityResult.none) {
        _goToCheckScreen('اتصال اینترنت خود را فعال کنید');

        return;
      }

      final result = await ApiService.get('/health');

      if (result != null) {
        message.value = result['message'] ?? 'پاسخی از سرور دریافت نشد';

        serverOk.value =
            (result['message'] == 'normal' ||
            result['status'] == 200 ||
            result['statusCode'] == 200);
      } else {
        serverOk.value = false;
        message.value = 'سرور در دسترس نیست';
      }
    } catch (e) {
      _goToCheckScreen('خطا در اتصال به سرور');
    } finally {
      serverLoading.value = false;
    }
  }

  Future<void> checkLocation() async {
    locationLoading.value = true;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _goToCheckScreen('سرویس موقعیت غیرفعال است');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _goToCheckScreen('دسترسی به موقعیت رد شده است');
        return;
      }

      // گرفتن موقعیت فعلی
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 3),
        ),
      );

      currentPosition.value = pos;
    } catch (e) {
      debugPrint("❌ خطا در initLocation: $e");
      _goToCheckScreen('خطا در دریافت موقعیت');
    } finally {
      locationLoading.value = false;
    }
  }
}

void _goToCheckScreen(String msg) {
  showErrorToast(description: msg);

  // بستن تمام صفحات و رفتن به صفحه چک
  Future.microtask(() {
    if (Get.currentRoute != AppRoutes.checkScreen) {
      Get.offAllNamed(AppRoutes.checkScreen);
    }
  });
}
