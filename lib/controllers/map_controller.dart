import 'dart:async';

import 'package:bike/screens/map/widgets/station_bottom_sheet.dart';
import 'package:bike/screens/models.dart';
import 'package:bike/widgets/pulsing_user_dot.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

/// -----------------------
/// Controller with GetX
/// -----------------------
class MapControllerX extends GetxController {
  final MapController mapController = MapController();
  final RxBool showSearchBox = false.obs;
  final stations2 = <Station>[].obs;

  /// لوکیشن فعلی کاربر
  final Rxn<Position> currentPosition = Rxn<Position>();

  /// مارکرها (بهینه‌سازی شده)
  final markers = <Marker>[].obs;

  StreamSubscription<Position>? _positionStreamSub;

  /// Stations (preserve your original list exactly)
  final RxList<Station> stations = <Station>[
    Station(
      id: 's1',
      name: 'ایستگاه مرکزی یزد',
      lat: 31.8974,
      lng: 54.3569,
      description: 'نزدیک میدان امیر چقماق ( شماره 505 )',
      iconAsset: 'assets/img/point.png',
      availableBikes: 5,
      availableParking: 10,
      numberOfStation: 101,
      workTime: '16:00 - 8:00',
      type: StationType.bike,
    ),
    Station(
      id: 's2',
      name: 'ایستگاه باغ دولت‌آباد',
      lat: 31.8810,
      lng: 54.3598,
      description: 'نزدیک باغ دولت‌آباد ( ایستگاه 402 )',
      iconAsset: 'assets/img/point.png',
      availableBikes: 2,
      availableParking: 8,
      numberOfStation: 101,
      workTime: '16:00 - 8:00',
      type: StationType.bike,
    ),
    Station(
      id: 's3',
      name: 'ایستگاه میدان خان',
      lat: 31.8903,
      lng: 54.3610,
      description: 'میدان خان ( شماره 301 )',
      iconAsset: 'assets/img/point.png',
      availableBikes: 7,
      availableParking: 20,
      numberOfStation: 101,
      workTime: '16:00 - 8:00',
      type: StationType.eBike,
    ),
    Station(
      id: 's4',
      name: 'ایستگاه پارک کوهستان',
      lat: 31.8789,
      lng: 54.3665,
      description: 'کنار ورودی پارک کوهستان ( شماره 200 )',
      iconAsset: 'assets/img/point.png',
      availableBikes: 4,
      availableParking: 4,
      numberOfStation: 101,
      workTime: '16:00 - 8:00',
      type: StationType.eBike,
    ),
    Station(
      id: 's5',
      name: 'ایستگاه دانشگاه یزد',
      lat: 31.8534,
      lng: 54.3671,
      description: 'جنب ورودی اصلی دانشگاه یزد ( شماره 101 )',
      iconAsset: 'assets/img/point.png',
      availableBikes: 6,
      availableParking: 2,
      numberOfStation: 101,
      workTime: '16:00 - 8:00',
      type: StationType.scooter,
    ),
    Station(
      id: 's6',
      name: 'ایستگاه برج ساعت',
      lat: 31.9025,
      lng: 54.3554,
      description: 'میدان ساعت یزد ( شماره 68 )',
      iconAsset: 'assets/img/point.png',
      availableBikes: 3,
      availableParking: 5,
      numberOfStation: 101,
      workTime: '16:00 - 8:00',
      type: StationType.scooter,
    ),
    Station(
      id: 's7',
      name: 'ایستگاه ورودی بازار خان',
      lat: 31.8935,
      lng: 54.3620,
      description: 'ورودی بازار خان یزد ( شماره 50 )',
      iconAsset: 'assets/img/point.png',
      availableBikes: 8,
      availableParking: 1,
      numberOfStation: 101,
      workTime: '16:00 - 8:00',
      type: StationType.smartParking,
    ),
  ].obs;

  /// Called when controller is created
  @override
  void onInit() {
    super.onInit();
    _initLocation();
    updateMarkers(); // اول کار
  }

  /// Clean up: cancel subscription to avoid any post-dispose updates
  @override
  void onClose() {
    _positionStreamSub?.cancel();
    super.onClose();
  }

  Future<void> _initLocation() async {
    bool permissionGranted = false;

    while (!permissionGranted) {
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          // اگر سرویس خاموش بود، به کاربر پیام بده
          await Get.defaultDialog(
            title: "لوکیشن خاموش است",
            middleText: "برای استفاده از نقشه، لوکیشن خود را روشن کنید",
            textConfirm: "باشه",
            onConfirm: () => Get.back(),
          );
          continue; // دوباره بررسی کن
        }

        LocationPermission permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            await Get.defaultDialog(
              title: "مجوز لوکیشن لازم است",
              middleText: "برای استفاده از نقشه، اجازه دسترسی به لوکیشن بدهید",
              textConfirm: "تلاش دوباره",
              onConfirm: () => Get.back(),
            );
            continue;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          await Get.defaultDialog(
            title: "مجوز لوکیشن مسدود شده",
            middleText:
                "برای استفاده از نقشه، باید مجوز لوکیشن را از تنظیمات سیستم فعال کنید",
            textConfirm: "رفتن به تنظیمات",
            onConfirm: () {
              Geolocator.openAppSettings(); // باز کردن تنظیمات دستگاه
              Get.back();
            },
          );
          continue;
        }

        // رسیدیم به اینجا یعنی اجازه گرفته شده
        permissionGranted = true;

        try {
          // گرفتن موقعیت اولیه
          final pos = await Geolocator.getCurrentPosition(
            // ignore: deprecated_member_use
            desiredAccuracy: LocationAccuracy.best,
          );
          currentPosition.value = pos;
          _recalculateDistances();

          //! زوم روی جای کاربر
          // mapController.move(LatLng(pos.latitude, pos.longitude), 15);
        } catch (e) {
          debugPrint("خطا در گرفتن موقعیت: $e");
          await Get.defaultDialog(
            title: "خطا در موقعیت‌یابی",
            middleText:
                "امکان گرفتن موقعیت وجود ندارد. لطفاً دوباره تلاش کنید.",
            textConfirm: "باشه",
            onConfirm: () => Get.back(),
          );
          return; // چون موقعیت نگرفتیم، ادامه نده
        }

        // شروع استریم لوکیشن
        _positionStreamSub =
            Geolocator.getPositionStream(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.best,
                distanceFilter: 10,
              ),
            ).listen(
              (Position position) {
                currentPosition.value = position;
                _recalculateDistances();
              },
              onError: (e) {
                debugPrint("خطا در استریم موقعیت: $e");
                Get.defaultDialog(
                  title: "خطا در موقعیت‌یابی",
                  middleText: "دریافت موقعیت متوقف شد. لطفاً دوباره تلاش کنید.",
                  textConfirm: "باشه",
                  onConfirm: () => Get.back(),
                );
              },
            );
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
  }

  /// ساخت مارکرها
  void updateMarkers() {
    final list = <Marker>[];

    // مارکر ایستگاه‌ها
    for (var s in stations) {
      list.add(
        Marker(
          point: LatLng(s.lat, s.lng),
          width: 65,
          height: 65,
          child: GestureDetector(
            onTap: () => onMarkerTap(Get.context!, s),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (s.distanceKm >= 0)
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 6,
                  //     vertical: 3,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Get.theme.colorScheme.onPrimary,
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: Text(
                  //     '${s.distanceKm.toStringAsFixed(2)} km',
                  //     style: const TextStyle(fontSize: 10),
                  //   ),
                  // ),
                  Image.asset(s.iconAsset, width: 44, height: 44),
              ],
            ),
          ),
        ),
      );
    }

    // مارکر کاربر
    if (currentPosition.value != null) {
      final pos = currentPosition.value!;
      list.add(
        Marker(
          point: LatLng(pos.latitude, pos.longitude),
          width: 40,
          height: 40,
          child: const Center(child: PulsingUserDot()),
        ),
      );
    }

    markers.assignAll(list);
  }

  void _recalculateDistances() {
    final pos = currentPosition.value;
    if (pos == null) return;
    final userLatLng = LatLng(pos.latitude, pos.longitude);
    final Distance distance = const Distance();

    final updated = stations.map((s) {
      final dMeters = distance(userLatLng, LatLng(s.lat, s.lng));
      s.distanceKm = (dMeters / 1000);
      return s;
    }).toList();

    updated.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    stations.assignAll(updated);

    /// بعد از آپدیت فاصله‌ها → مارکرها هم آپدیت شن
    updateMarkers();
  }

  void onMarkerTap(BuildContext context, Station station) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StationBottomSheet(
          station: station,
          userPosition: currentPosition.value,
          onRequestBike: () {},
          onManage: () => Navigator.pop(context),
        );
      },
    );
  }
}
