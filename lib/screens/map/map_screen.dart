// map_screen_getx.dart
import 'package:bike/controllers/map_controller.dart';
import 'package:bike/screens/map/widgets/loading_get_location_card.dart';
import 'package:bike/screens/map/widgets/search_button.dart';
import 'package:bike/screens/map/widgets/search_box.dart';
import 'package:bike/widgets/drawer_avatar.dart';
import 'package:bike/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

/// -----------------------
/// MapScreen (Stateless + GetX)
/// -----------------------
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _stationNameController = TextEditingController();

  @override
  void dispose() {
    _stationNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MapControllerX controller = Get.find<MapControllerX>();

    return Scaffold(
      endDrawer: const MyDrawer(),
      body: Stack(
        children: [
          /// نقشه
          RepaintBoundary(
            child: FlutterMap(
              mapController: controller.mapController,
              options: const MapOptions(
                initialCenter: LatLng(31.8974, 54.3569),
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.bikeshare',
                ),
    
                /// فقط مارکرها reactive هستن
                // داخل FlutterMap > children
                Obx(() {
                  // ثبت وابستگی
                  final _ = controller.markers.length;
                  // پاس‌دادن snapshot تا MarkerLayer لیست stable بگیره
                  final markersSnapshot = List<Marker>.from(
                    controller.markers,
                  );
                  return MarkerLayer(markers: markersSnapshot);
                }),
              ],
            ),
          ),
    
          /// اگر لوکیشن آماده نیست
          Obx(
            () => controller.currentPosition.value == null
                ? const LoadingGetLocationCard()
                : const SizedBox.shrink(),
          ),
    
          /// دکمه سرچ
          SearchButton(showSearchBox: controller.showSearchBox),
    
          /// باکس سرچ
          Obx(
            () => controller.showSearchBox.value
                ? Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: SearchBox(
                        showSearchBox: controller.showSearchBox,
                        stationNameController: _stationNameController,
                        controller: controller,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
    
          /// آواتار
          const Positioned(top: 40, right: 16, child: DrawerAvatar()),
        ],
      ),
    );
  }
}
