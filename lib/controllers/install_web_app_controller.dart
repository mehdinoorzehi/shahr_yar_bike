// import 'package:bike/widgets/toast.dart';
// import 'package:get/get.dart';
// // ignore: deprecated_member_use, avoid_web_libraries_in_flutter
// import 'dart:html' as html;

// class InstallController extends GetxController {
//   static InstallController get instance => Get.find();

//   html.BeforeInstallPromptEvent? deferredPrompt;

//   @override
//   void onInit() {
//     super.onInit();

//     // گوش دادن به رویداد beforeinstallprompt
//     html.window.addEventListener('beforeinstallprompt', (event) {
//       event.preventDefault(); // جلوگیری از نمایش خودکار
//       deferredPrompt = event as html.BeforeInstallPromptEvent;
//       print('✅ beforeinstallprompt دریافت شد');
//     });
//   }

//   Future<void> showInstallPrompt() async {
//     if (deferredPrompt != null) {
//       deferredPrompt!.prompt();
//       final result = await deferredPrompt!.userChoice;
//       if (result != null && result['outcome'] == 'accepted') {
//         print('✅ کاربر نصب را تأیید کرد');
//       } else {
//         print('❌ کاربر نصب را رد کرد');
//       }
//       deferredPrompt = null;
//     } else {
//       showInfoToast(
//         description:
//             "برای نصب، از منوی مرورگر گزینه‌ی «افزودن به صفحه اصلی» را بزنید",
//       );
//     }
//   }
// }
