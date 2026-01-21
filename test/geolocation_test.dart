import 'package:flutter_test/flutter_test.dart';
import 'package:coco/src/features/filters/domain/services/geolocation_service.dart';
import 'package:coco/src/features/filters/domain/models/person_entity.dart';

void main() {
  test(
    'searchNearby returns only items within radius and respects type filter',
    () {
      const centerLat = 48.8566;
      const centerLng = 2.3522;

      final items = [
        PersonEntity(
          id: 'p1',
          lastName: 'One',
          firstName: 'Person',
          gender: 'H',
          age: 20,
          lat: 48.8566,
          lng: 2.3522,
        ),
        PersonEntity(
          id: 'p2',
          lastName: 'Two',
          firstName: 'Person',
          gender: 'F',
          age: 22,
          lat: 48.8600,
          lng: 2.3600,
        ),
        PersonEntity(
          id: 'p3',
          lastName: 'Three',
          firstName: 'Person',
          gender: 'H',
          age: 30,
          lat: 49.0000,
          lng: 3.0000,
        ),
        EventEntity(
          id: 'e1',
          title: 'E1',
          lat: 48.8566,
          lng: 2.3522,
          metadata: {},
        ),
      ];

      final service = GeolocationService();

      final radius = 6000.0;
      final people = service.searchNearby(
        items,
        centerLat,
        centerLng,
        radius,
        typeFilter: 'person',
      );

      expect(people.every((p) => p.type == 'person'), isTrue);

      for (final p in people) {
        final d = service.distanceMeters(centerLat, centerLng, p.lat, p.lng);
        expect(d <= radius + 1e-6, isTrue);
      }

      expect(people.any((p) => p.id == 'p1'), isTrue);
      expect(people.any((p) => p.id == 'p2'), isTrue);
      expect(people.any((p) => p.id == 'p3'), isFalse);
      expect(people.any((p) => p.id == 'e1'), isFalse);
    },
  );
}
