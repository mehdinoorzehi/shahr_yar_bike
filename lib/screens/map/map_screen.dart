// map_screen_getx_optimized.dart
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
          // ---------- MAP ----------
          RepaintBoundary(
            child: FlutterMap(
              mapController: controller.mapController,
              options: const MapOptions(
                initialCenter: LatLng(31.8974, 54.3569),
                initialZoom: 13,
                minZoom: 3,
                maxZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.bikeshare',
                  errorTileCallback: (tile, error, stackTrace) {
                    debugPrint('Tile load failed: $tile, error: $error');
                  },
                ),

                /// Marker reactive با rebuild حداقلی
                Obx(() {
                  final markersSnapshot = List<Marker>.from(controller.markers);
                  return MarkerLayer(markers: markersSnapshot);
                }),
              ],
            ),
          ),

          /// Loading location
          Obx(() => controller.isLoading.value
              ? const LoadingGetLocationCard()
              : const SizedBox.shrink()),

          /// Search button
          SearchButton(showSearchBox: controller.showSearchBox),

          /// Search box overlay
          Obx(() => controller.showSearchBox.value
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
              : const SizedBox.shrink()),

          /// Drawer avatar
          const Positioned(top: 40, right: 16, child: DrawerAvatar()),
        ],
      ),
    );
  }
}
