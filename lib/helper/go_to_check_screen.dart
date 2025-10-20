import 'package:bike/app_routes.dart';
import 'package:bike/controllers/initial_controller.dart';
import 'package:get/get.dart';

void goToCheckScreen() {
  if (Get.currentRoute != AppRoutes.checkScreen) {
    // 🧠 اگر کنترلر ثبت شده است، وضعیت را ریست کن
    if (Get.isRegistered<InitialController>()) {
      final crt = Get.find<InitialController>();
      crt.serverOk.value = false;
      crt.message.value = 'internet_connection_error'.tr;
    }

    // 🚀 بستن همه صفحات و رفتن به صفحه چک فقط اگر الان در آن نیستیم
    Future.microtask(() {
      Get.offAllNamed(AppRoutes.checkScreen);
    });
  }
}
