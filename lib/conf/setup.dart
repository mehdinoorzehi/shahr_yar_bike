import 'package:bike/controllers/authentication_controller.dart';
import 'package:bike/controllers/internet_controller.dart';
import 'package:bike/controllers/main_controller.dart';
import 'package:bike/controllers/map_controller.dart';
import 'package:bike/controllers/initial_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
// import 'package:pwa_install/pwa_install.dart';

// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
// import 'package:shared_preferences/shared_preferences.dart';

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ✅ مقداردهی اولیه PWAInstall
  // PWAInstall().setup(installCallback: () {
  //   debugPrint('APP INSTALLED!');
  // });
  // ✅ تمام سیستم UI overlays رو شفاف و هم‌سطح محتوا کن
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // نوار وضعیت شفاف
      systemNavigationBarColor: Colors.transparent, // نوار پایین شفاف
      statusBarIconBrightness: Brightness.light, // آیکون‌های سفید
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  //
  //
  //
  //! lock auto rotation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Get.put(InternetController());
  Get.lazyPut(() => InitialController(), fenix: true);
  // Get.lazyPut(() => CheckAccessController(), fenix: true);
  Get.lazyPut(() => MapControllerX(), fenix: true);
  Get.lazyPut(() => MainController(), fenix: true);
  Get.lazyPut(() => AuthenticationController(), fenix: true);
  // Get.lazyPut(() => OnBoardingController(), fenix: true);
  // Get.lazyPut(() => LoginController(), fenix: true);

  if (kIsWeb) {
    usePathUrlStrategy(); // حذف هش از URL
  }
}
