import 'dart:async';
import 'package:bike/app_routes.dart';
import 'package:bike/screens/map/widgets/station_bottom_sheet.dart';
import 'package:bike/models/models.dart';
import 'package:bike/widgets/pulsing_user_dot.dart';
import 'package:bike/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapControllerX extends GetxController {
  final MapController mapController = MapController();
  var isLoading = false.obs;
  final RxBool showSearchBox = false.obs;
  final stations2 = <Station>[].obs;
  final Rxn<Position> currentPosition = Rxn<Position>();
  final markers = <Marker>[].obs;
  StreamSubscription<Position>? _positionStreamSub;

  /// ایستگاه‌ها
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
  ].obs;

  @override
  void onInit() {
    super.onInit();
    initLocation();
    updateMarkers();
  }

  @override
  void onClose() {
    _positionStreamSub?.cancel();
    super.onClose();
  }

  Future<void> initLocation() async {

    try {
      // گرفتن موقعیت فعلی
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 3),
        ),
      );

      currentPosition.value = pos;
      _recalculateDistances();

      // استریم موقعیت
      _positionStreamSub?.cancel();
      _positionStreamSub =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.best,
              distanceFilter: 10,
            ),
          ).listen(
            (position) {
              currentPosition.value = position;
              _recalculateDistances();
            },
            onError: (e) {
              debugPrint("❌ خطا در استریم موقعیت: $e");
              _goToCheckScreen('دسترسی به موقعیت قطع شد');
            },
          );
    } catch (e) {
      debugPrint("❌ خطا در initLocation: $e");
      _goToCheckScreen('خطا در دریافت موقعیت');
    } finally {
      isLoading.value = false;
    }
  }

  void _goToCheckScreen(String msg) {
    showErrorToast(description: msg);
    _positionStreamSub?.cancel();
    currentPosition.value = null;

    // بستن تمام صفحات و رفتن به صفحه چک
    Future.microtask(() {
      if (Get.currentRoute != AppRoutes.checkScreen) {
        Get.offAllNamed(AppRoutes.checkScreen);
      }
    });
  }

  /// ساخت مارکرها
  void updateMarkers() {
    final list = <Marker>[];

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
                  Image.asset(s.iconAsset, width: 44, height: 44),
              ],
            ),
          ),
        ),
      );
    }

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
    }).toList()..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    stations.assignAll(updated);
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
