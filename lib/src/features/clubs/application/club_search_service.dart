import '../domain/repositories/club_repository.dart';
import '../domain/models/club_entity.dart';
import '../domain/models/club_sport_catalog.dart';
import '../domain/models/sport_config.dart';

class ClubSearchService {
  final ClubRepository _clubRepository;

  ClubSearchService({required ClubRepository clubRepository})
    : _clubRepository = clubRepository;

  Future<List<ClubEntity>> searchNearby({
    required double lat,
    required double lng,
    double radiusKm = 10.0,
    List<String>? activities,
    List<String>? levels,
  }) async {
    final normalizedActivities = activities == null
        ? const <String>[]
        : ClubSportCatalog.normalizeKeys(activities);
    final clubs = await _clubRepository.searchClubsByLocation(
      lat: lat,
      lng: lng,
      radiusKm: radiusKm,
      activities: normalizedActivities,
    );

    return clubs.where((club) => club.isSubscriptionActive).toList()
      ..sort((a, b) {
        final distA = _calculateDistance(lat, lng, a.lat, a.lng);
        final distB = _calculateDistance(lat, lng, b.lat, b.lng);
        return distA.compareTo(distB);
      });
  }

  Future<List<ClubEntity>> searchByOwnerId(String ownerId) async {
    return await _clubRepository.getClubsByOwnerId(ownerId);
  }

  Future<List<ClubEntity>> getAllActiveClubs() async {
    return await _clubRepository.getActiveClubs();
  }

  Future<List<String>> getAvailableSports() async {
    final clubs = await _clubRepository.getActiveClubs();
    final sports = clubs.expand((c) => c.normalizedActivities).toSet().toList();
    sports.sort(
      (a, b) =>
          ClubSportCatalog.labelFor(a).compareTo(ClubSportCatalog.labelFor(b)),
    );
    return sports;
  }

  Future<SportConfig> getSportConfig(String activityKey) async {
    try {
      final type = SportType.values.firstWhere(
        (e) => e.name == ClubSportCatalog.normalizeKey(activityKey),
        orElse: () => SportType.other,
      );
      return SportConfig.forSport(type);
    } catch (e) {
      return SportConfig.forSport(SportType.other);
    }
  }

  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const double earthRadius = 6371;
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);
    final a =
        _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(_toRadians(lat1)) *
            _cos(_toRadians(lat2)) *
            _sin(dLng / 2) *
            _sin(dLng / 2);
    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * 3.14159265359 / 180.0;
  double _sin(double x) => x - (x * x * x) / 6 + (x * x * x * x * x) / 120;
  double _cos(double x) => 1 - (x * x) / 2 + (x * x * x * x) / 24;
  double _sqrt(double x) {
    if (x == 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  double _atan2(double y, double x) {
    if (x > 0) return _atan(y / x);
    if (x < 0 && y >= 0) return _atan(y / x) + 3.14159265359;
    if (x < 0 && y < 0) return _atan(y / x) - 3.14159265359;
    if (x == 0 && y > 0) return 3.14159265359 / 2;
    if (x == 0 && y < 0) return -3.14159265359 / 2;
    return 0;
  }

  double _atan(double x) {
    double result = x;
    double term = x;
    for (int i = 1; i < 10; i++) {
      term *= -x * x;
      result += term / (2 * i + 1);
    }
    return result;
  }
}
