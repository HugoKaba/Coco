import '../domain/models/person_entity.dart';
import '../domain/models/filter_criteria.dart';
import '../domain/services/geolocation_service.dart';

class SearchFilters {
  static List<PersonEntity> apply(
    List<PersonEntity> users,
    FilterCriteria criteria,
    double centerLat,
    double centerLng,
    GeolocationService geoService,
  ) {
    final out = <MapEntry<PersonEntity, double>>[];
    for (final p in users) {
      final d = geoService.distanceMeters(centerLat, centerLng, p.lat, p.lng);
      if (d > criteria.radius) {
        continue;
      }

      bool sportMatch = true;
      if (criteria.selectedSports.isNotEmpty) {
        final matches = p.sports.where(
          (s) => criteria.selectedSports.contains(s.sportId),
        );
        if (matches.isEmpty) {
          sportMatch = false;
        } else if (criteria.selectedLevel != null &&
            !matches.any((s) => s.levelId == criteria.selectedLevel)) {
          sportMatch = false;
        }
      } else if (criteria.selectedLevel != null &&
          !p.sports.any((s) => s.levelId == criteria.selectedLevel)) {
        sportMatch = false;
      }

      if (!sportMatch) {
        continue;
      }

      if (criteria.selectedAvailabilities.isNotEmpty &&
          !p.availabilities.any(
            (a) => criteria.selectedAvailabilities.contains(a),
          )) {
        continue;
      }

      if (p.age < criteria.ageRange.start || p.age > criteria.ageRange.end) {
        continue;
      }

      out.add(MapEntry(p, d));
    }
    out.sort((a, b) => a.value.compareTo(b.value));
    return out.map((e) => e.key).toList();
  }
}
