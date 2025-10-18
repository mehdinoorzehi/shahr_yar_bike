import 'package:bike/app_routes.dart';
import 'package:bike/controllers/initial_controller.dart';
import 'package:get/get.dart';

void goToCheckScreen(String msg) {
  // نمایش ارور در همان لحظه
  // showErrorToast(description: msg);

  // 🧠 اگر کنترلر ثبت شده است، وضعیت را ریست کن
  if (Get.isRegistered<InitialController>()) {
    final ctrl = Get.find<InitialController>();
    ctrl.serverOk.value = false;
    ctrl.message.value = msg;
  }

  // 🚀 بستن همه صفحات و رفتن به صفحه چک فقط اگر الان در آن نیستیم
  Future.microtask(() {
    if (Get.currentRoute != AppRoutes.checkScreen) {
      Get.offAllNamed(AppRoutes.checkScreen);
    }
  });
}
