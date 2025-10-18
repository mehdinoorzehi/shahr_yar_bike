import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:geolocator/geolocator.dart';
import 'package:universal_html/html.dart' as html;

/// 📍 فقط موقعیت واقعی از سنسور دستگاه.
/// بدون هیچ fallback اینترنتی یا IP-based.
Future<Position?> safeGetCurrentPosition() async {
  try {
    if (kIsWeb) {
      // 🌐 حالت وب — استفاده از Geolocation API مرورگر
      final pos = await html.window.navigator.geolocation
          .getCurrentPosition(enableHighAccuracy: true)
          .timeout(const Duration(seconds: 8));

      final coords = pos.coords!;
      final position = Position(
        latitude: coords.latitude?.toDouble() ?? 0,
        longitude: coords.longitude?.toDouble() ?? 0,
        accuracy: coords.accuracy?.toDouble() ?? 100,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
        timestamp: DateTime.now(),
      );

      if (kDebugMode) {
        print('🌍 [Web Geolocation] ✅ lat=${position.latitude}, lng=${position.longitude}');
      }
      return position;
    } else {
      // 📱 حالت موبایل — استفاده از Geolocator
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('location_disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('location_denied');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );

      if (kDebugMode) {
        print('📱 [Mobile Geolocator] ✅ lat=${position.latitude}, lng=${position.longitude}');
      }
      return position;
    }
  } catch (e) {
    if (kDebugMode) {
      print('❌ [Location Error] $e');
    }
    return null;
  }
}
