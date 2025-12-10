import 'package:flutter_test/flutter_test.dart';
import 'package:sportlinker/src/features/filters/services/geolocation_service.dart';
import 'package:sportlinker/src/features/filters/models/location_entity.dart';

void main() {
  test('boundary exact radius and zero radius behave correctly', () {
    const centerLat = 48.8566;
    const centerLng = 2.3522;

    // Inline fake data
    final items = [
      PersonEntity(
        id: 'c1',
        name: 'City1',
        lat: 48.8566,
        lng: 2.3522,
      ), // At center
      PersonEntity(
        id: 'c2',
        name: 'City2',
        lat: 48.9000,
        lng: 2.4000,
      ), // Nearby
    ];

    final service = GeolocationService();

    // Pick a known point: first item
    final first = items.first;
    final d = service.distanceMeters(
      centerLat,
      centerLng,
      first.lat,
      first.lng,
    );

    // radius exactly at d should include the point
    final resExact = service.searchNearby(items, centerLat, centerLng, d);
    expect(resExact.contains(first), isTrue);

    // radius zero should only include exact same coordinate
    final resZero = service.searchNearby(items, centerLat, centerLng, 0.0);
    // if there is a point exactly at center it's included, otherwise empty
    expect(
      resZero.every(
        (p) =>
            service.distanceMeters(centerLat, centerLng, p.lat, p.lng) <=
            0.0 + 1e-9,
      ),
      isTrue,
    );
  });

  test('performance smoke test with many items completes', () {
    const centerLat = 48.8566;
    const centerLng = 2.3522;
    final service = GeolocationService();

    // create many copies of cities to simulate load
    final base = [
      PersonEntity(id: 'c1', name: 'City1', lat: 48.8566, lng: 2.3522),
      PersonEntity(id: 'c2', name: 'City2', lat: 48.9000, lng: 2.4000),
      PersonEntity(id: 'c3', name: 'City3', lat: 49.0000, lng: 3.0000),
    ];

    final big = <LocationEntity>[];
    for (var i = 0; i < 2000; i++) {
      big.addAll(base);
    }

    final stopwatch = Stopwatch()..start();
    final out = service.searchNearby(big, centerLat, centerLng, 50000.0);
    stopwatch.stop();
    // ensure it returned a list (and completed)
    expect(out, isNotNull);
    // Print time for information
    // ignore: avoid_print
    print(
      'Search over ${big.length} items took: ${stopwatch.elapsedMilliseconds}ms',
    );
  });
}
