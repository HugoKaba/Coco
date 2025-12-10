import 'package:flutter_test/flutter_test.dart';
import 'package:sportlinker/src/features/filters/services/geolocation_service.dart';
import 'package:sportlinker/src/features/filters/models/location_entity.dart';

void main() {
  test(
    'searchNearby returns only items within radius and respects type filter',
    () {
      const centerLat = 48.8566;
      const centerLng = 2.3522;

      // Create inline fake data
      final items = [
        PersonEntity(
          id: 'p1',
          name: 'P1',
          lat: 48.8566,
          lng: 2.3522,
        ), // At center
        PersonEntity(id: 'p2', name: 'P2', lat: 48.8600, lng: 2.3600), // Nearby
        PersonEntity(
          id: 'p3',
          name: 'P3',
          lat: 49.0000,
          lng: 3.0000,
        ), // Far away
        EventEntity(
          id: 'e1',
          title: 'E1',
          lat: 48.8566,
          lng: 2.3522,
          metadata: {},
        ), // Event at center
      ];

      final service = GeolocationService();

      final radius = 6000.0; // 6km
      final people = service.searchNearby(
        items,
        centerLat,
        centerLng,
        radius,
        typeFilter: 'person',
      );

      // All returned must be type person
      expect(people.every((p) => p.type == 'person'), isTrue);

      // Distances should be <= radius
      for (final p in people) {
        final d = service.distanceMeters(centerLat, centerLng, p.lat, p.lng);
        expect(d <= radius + 1e-6, isTrue);
      }

      // Check specific results
      // p1 and p2 should be in, p3 out, e1 out (wrong type)
      expect(people.any((p) => p.id == 'p1'), isTrue);
      expect(people.any((p) => p.id == 'p2'), isTrue);
      expect(people.any((p) => p.id == 'p3'), isFalse);
      expect(people.any((p) => p.id == 'e1'), isFalse);
    },
  );
}
