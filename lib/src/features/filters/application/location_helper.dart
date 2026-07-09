import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:easy_localization/easy_localization.dart';

class LocationHelper {
  static Future<Position?> initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      // Timeout : sur simulateur (ou si le GPS ne répond pas), getCurrentPosition
      // peut ne jamais revenir et bloquer l'app. Au-delà du délai → position null.
      return await Geolocator.getCurrentPosition().timeout(
        const Duration(seconds: 8),
      );
    } catch (e) {
      debugPrint('${tr("errors.location_error")}: $e');
      return null;
    }
  }

  static double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng) /
        1000;
  }

  static Future<List<Location>> getCoordinatesFromAddress(
    String address,
  ) async {
    try {
      return await locationFromAddress(address);
    } catch (e) {
      debugPrint('${tr("errors.geocoding_error")}: $e');
      return [];
    }
  }
}
