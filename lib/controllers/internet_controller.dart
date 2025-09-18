// import 'dart:async';

// import 'package:bike/widgets/toast.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:get/get.dart';

// class InternetController extends GetxController {
//   RxBool isConnected = true.obs;
//   late StreamSubscription subscription;

//   // InternetController(this.context);

//   @override
//   void onReady() {
//     super.onReady();
//     _checkInitialConnection();
//     _monitorInternetConnection();
//   }

//   Future<void> _checkInitialConnection() async {
//     final connectivityResult = await Connectivity().checkConnectivity();
//     _updateConnectionStatus(connectivityResult);
//   }

//   void _monitorInternetConnection() {
//     subscription = Connectivity().onConnectivityChanged.listen((results) {
//       _updateConnectionStatus(results);
//     });
//   }

//   void _updateConnectionStatus(List<ConnectivityResult> results) {
//     if (results.contains(ConnectivityResult.none)) {
//       if (isConnected.value) {
//         // _showErrorDialog();
//         showErrorToast(description: 'لطفا اتصال به اینترنت خود را بررسی کنید');
//       }
//       isConnected.value = false;
//     } else {
//       if (!isConnected.value) {
//         // _closeErrorDialog();
//         showSuccsesToast(description: 'آنلاین شدید');
//       }
//       isConnected.value = true;
//     }
//   }

//   @override
//   void onClose() {
//     subscription.cancel();
//     super.onClose();
//   }
// }
