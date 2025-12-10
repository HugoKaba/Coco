import 'dart:math';
import '../models/location_entity.dart';

/// Simple grid-based spatial index (prototype of geohash).
/// It buckets points into lat/lng cells of size 1/precision degrees.
class CellIndex<T extends LocationEntity> {
  final double precision; // e.g. 100 means cell = 0.01 deg
  final Map<String, List<T>> _cells = {};

  CellIndex({this.precision = 100});

  String _cellKey(double lat, double lng) {
    return '${(lat * precision).floor()}:${(lng * precision).floor()}';
  }

  void build(List<T> items) {
    _cells.clear();
    for (final it in items) {
      final k = _cellKey(it.lat, it.lng);
      _cells.putIfAbsent(k, () => []).add(it);
    }
  }

  /// Query candidates within a bounding box that covers radiusMeters around center.
  List<T> queryCandidates(
    double centerLat,
    double centerLng,
    double radiusMeters,
  ) {
    final dmLat = radiusMeters / 111320.0; // ~deg per meter
    final dmLng = radiusMeters / (111320.0 * cos(centerLat * pi / 180));
    final minLat = centerLat - dmLat;
    final maxLat = centerLat + dmLat;
    final minLng = centerLng - dmLng;
    final maxLng = centerLng + dmLng;

    final minKeyLat = (minLat * precision).floor();
    final maxKeyLat = (maxLat * precision).floor();
    final minKeyLng = (minLng * precision).floor();
    final maxKeyLng = (maxLng * precision).floor();

    final out = <T>[];
    for (var ky = minKeyLat; ky <= maxKeyLat; ky++) {
      for (var kx = minKeyLng; kx <= maxKeyLng; kx++) {
        final k = '\$ky:\$kx';
        final list = _cells[k];
        if (list != null) out.addAll(list);
      }
    }
    return out;
  }
}
