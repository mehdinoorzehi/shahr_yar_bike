import 'package:bike/controllers/check_access_controller.dart';
import 'package:bike/controllers/main_controller.dart';
import 'package:bike/controllers/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
// import 'package:shared_preferences/shared_preferences.dart';

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  //! change status bar color

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // statusBarIconBrightness: Brightness.light,
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
  Get.lazyPut(() => CheckAccessController(), fenix: true);
  Get.lazyPut(() => MapControllerX(), fenix: true);
  Get.lazyPut(() => MainController(), fenix: true);

  // if (kIsWeb) {
  //   usePathUrlStrategy(); // حذف هش از URL
  // }
}
