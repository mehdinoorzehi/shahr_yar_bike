// map_controller_getx_optimized.dart
import 'dart:async';
import 'package:bike/helper/location_helper.dart';
import 'package:bike/screens/map/widgets/station_bottom_sheet.dart';
import 'package:bike/models/models.dart';
import 'package:bike/widgets/pulsing_user_dot.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:rxdart/rxdart.dart'; // برای debounce

class MapControllerX extends GetxController {
  final MapController mapController = MapController();
  final isLoading = false.obs;
  final showSearchBox = false.obs;
  final stations2 = <Station>[].obs;
  final Rxn<Position> currentPosition = Rxn<Position>();
  final markers = <Marker>[].obs;

  StreamSubscription<Position>? _positionStreamSub;

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
  }

  @override
  void onClose() {
    _positionStreamSub?.cancel();
    super.onClose();
  }

  Future<void> initLocation() async {
    try {
      isLoading.value = true;

      final pos = await safeGetCurrentPosition();
      if (pos == null) {
        debugPrint('خطا در دریافت موقعیت');
        return;
      }
      currentPosition.value = pos;
      _recalculateDistances();

      // ---------- Debounced location stream ----------
      _positionStreamSub?.cancel();
      _positionStreamSub =
          Geolocator.getPositionStream(
                locationSettings: const LocationSettings(
                  accuracy: LocationAccuracy.best,
                  distanceFilter: 10,
                ),
              )
              .debounceTime(const Duration(milliseconds: 300))
              .listen(
                (position) {
                  currentPosition.value = position;
                  _recalculateDistances();
                },
                onError: (e) {
                  debugPrint("❌ خطا در استریم موقعیت: $e");
                },
              );
    } catch (e) {
      debugPrint("❌ خطا در initLocation: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------- Marker helpers ----------
  Marker _buildMarker(Station s) {
    return Marker(
      point: LatLng(s.lat, s.lng),
      width: 65,
      height: 65,
      child: GestureDetector(
        onTap: () => onMarkerTap(Get.context!, s),
        child: RepaintBoundary(
          child: s.distanceKm >= 0
              ? Image.asset(s.iconAsset, width: 44, height: 44)
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  Marker _buildUserMarker(Position pos) {
    return Marker(
      point: LatLng(pos.latitude, pos.longitude),
      width: 40,
      height: 40,
      child: const RepaintBoundary(child: PulsingUserDot()),
    );
  }

  void updateMarkers({bool force = false}) {
    final list = stations.map(_buildMarker).toList();
    if (currentPosition.value != null) {
      list.add(_buildUserMarker(currentPosition.value!));
    }

    // rebuild only if changed
    if (!listEquals(list, markers) || force) {
      markers.assignAll(list);
    }
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
