import 'dart:math';
import '../models/person_entity.dart';
import 'package:coco/src/features/filters/domain/services/geohash_index.dart';

class GeolocationService {
  const GeolocationService();

  double distanceMeters(double lat1, double lng1, double lat2, double lng2) {
    const R = 6371000.0;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lng2 - lng1);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRad(double deg) => deg * pi / 180;

  List<T> searchNearby<T extends LocationEntity>(
    List<T> items,
    double centerLat,
    double centerLng,
    double radiusMeters, {
    String? typeFilter,
    Map<String, dynamic>? metadataFilter,
    CellIndex<T>? index,
  }) {
    final candidates = index != null
        ? index.queryCandidates(centerLat, centerLng, radiusMeters)
        : items;

    final results = <_DistanceWrapper<T>>[];
    for (final it in candidates) {
      if (typeFilter != null && it.type != typeFilter) continue;
      if (metadataFilter != null) {
        var ok = true;
        for (final entry in metadataFilter.entries) {
          if (!it.metadata.containsKey(entry.key) ||
              it.metadata[entry.key] != entry.value) {
            ok = false;
            break;
          }
        }
        if (!ok) continue;
      }
      final d = distanceMeters(centerLat, centerLng, it.lat, it.lng);
      if (d <= radiusMeters) results.add(_DistanceWrapper(it, d));
    }
    results.sort((a, b) => a.distance.compareTo(b.distance));
    return results.map((w) => w.item).toList();
  }
}

class _DistanceWrapper<T> {
  final T item;
  final double distance;
  _DistanceWrapper(this.item, this.distance);
}
