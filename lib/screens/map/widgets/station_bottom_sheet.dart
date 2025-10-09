import 'package:bike/app_routes.dart';
import 'package:bike/models/models.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class StationBottomSheet extends StatelessWidget {
  final Station station;
  final Position? userPosition;
  final VoidCallback onRequestBike;
  final VoidCallback onManage;

  const StationBottomSheet({
    super.key,
    required this.station,
    required this.userPosition,
    required this.onRequestBike,
    required this.onManage,
  });

  // double _calcDistanceKm() {
  //   if (userPosition == null) return -1;
  //   final d = const Distance();
  //   final meters = d(
  //     LatLng(userPosition!.latitude, userPosition!.longitude),
  //     LatLng(station.lat, station.lng),
  //   );
  //   return meters / 1000;
  // }

  @override
  Widget build(BuildContext context) {
    // final distanceKm = _calcDistanceKm();
    final _theme = Theme.of(context);

    return Container(
      height: 650,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        gradient: LinearGradient(
          colors: [_theme.colorScheme.secondary, _theme.colorScheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // دسته کوچک بالای شیت
              Container(
                width: 60,
                height: 6,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: _theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // تصویر ایستگاه
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/img/Bitmap.png',
                  width: 160,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 14),

              // نام ایستگاه
              Text(
                station.name,
                style: TextStyle(
                  color: _theme.colorScheme.onPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // توضیح ایستگاه
              Text(
                station.description,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // کارت‌های اطلاعات
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _infoCard(
                    Icons.location_on,
                    "فاصله از شما",
                    station.distanceKm >= 0
                        ? "${station.distanceKm.toStringAsFixed(1)} کیلومتر"
                        : "نامشخص",
                  ),
                  _infoCard(
                    Icons.pedal_bike,
                    "دوچرخه‌ قابل ارائه",
                    "${station.availableBikes}",
                  ),
                  _infoCard(
                    Icons.local_parking,
                    "جای پارک",
                    "${station.availableParking}",
                  ),
                  _infoCard(
                    Icons.access_time,
                    "ساعت کاری ایستگاه",
                    station.workTime,
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // دکمه انتخاب دوچرخه
              SizedBox(
                width: Get.width,
                height: 60,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      builder: (ctx) =>
                          BikeListSheet(bikeCount: station.availableBikes),
                    );
                  },
                  icon: const Icon(Icons.directions_bike, color: Colors.white),
                  label: const Text(
                    "انتخاب دوچرخه",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // دکمه QR و پیدا کردن ایستگاه
              Row(
                children: [
                  _QrButton(theme: _theme),
                  const SizedBox(width: 10),
                  _FindStationButton(theme: _theme, station: station),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// شیت لیست دوچرخه‌ها
class BikeListSheet extends StatelessWidget {
  final int bikeCount;
  const BikeListSheet({super.key, required this.bikeCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 500,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const Text(
            "لیست دوچرخه‌ها",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              addAutomaticKeepAlives: false,
              itemCount: bikeCount,
              itemBuilder: (ctx, index) {
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Icon(Icons.pedal_bike, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "دوچرخه شماره ${index + 1}",
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(AppRoutes.bikeDetailsScreen);
                        },
                        child: const Text(
                          "دریافت",
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QrButton extends StatelessWidget {
  const _QrButton({required ThemeData theme}) : _theme = theme;

  final ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _theme.colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          Get.toNamed(AppRoutes.qrScan);
        },
        icon: const Icon(Icons.qr_code_scanner, size: 24),
        label: const Text(
          "اسکن QR",
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _FindStationButton extends StatelessWidget {
  const _FindStationButton({required ThemeData theme, required this.station})
    : _theme = theme;

  final ThemeData _theme;
  final Station station;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _theme.colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(LucideIcons.map_pin, size: 24),
        label: const Text(
          "مکان‌یابی",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          if (kIsWeb) {
            // روی وب → مستقیم گوگل‌مپ توی مرورگر باز بشه
            final url =
                "https://www.google.com/maps/dir/?api=1&destination=${station.lat},${station.lng}";
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              );
            }
          } else {
            try {
              final availableMaps = await MapLauncher.installedMaps;
              if (availableMaps.isNotEmpty && context.mounted) {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return SafeArea(
                      child: Wrap(
                        children: [
                          for (var map in availableMaps)
                            ListTile(
                              leading: SvgPicture.asset(
                                map.icon,
                                height: 30.0,
                                width: 30.0,
                              ),
                              title: Text(map.mapName),
                              onTap: () async {
                                Navigator.of(ctx).pop();
                                await map.showDirections(
                                  destination: Coords(station.lat, station.lng),
                                  destinationTitle: station.name,
                                );
                              },
                            ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                // fallback: اگر هیچ اپ نقشه‌ای نبود → گوگل‌مپ با maps_launcher
                MapsLauncher.launchCoordinates(
                  station.lat,
                  station.lng,
                  station.name,
                );
              }
            } catch (e) {
              debugPrint("خطا در باز کردن نقشه: $e");
              MapsLauncher.launchCoordinates(
                station.lat,
                station.lng,
                station.name,
              );
            }
          }
        },
      ),
    );
  }
}
