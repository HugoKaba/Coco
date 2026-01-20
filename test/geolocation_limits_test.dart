import 'package:flutter_test/flutter_test.dart';
import 'package:coco/src/features/filters/domain/services/geohash_index.dart';
import 'package:coco/src/features/filters/domain/models/person_entity.dart';

void main() {
  test('CellIndex should bucket items and query candidates correctly', () {
    final index = CellIndex<PersonEntity>();

    final parisUser = PersonEntity(
      id: "paris",
      nom: "Dupont",
      prenom: "Jean",
      genre: "H",
      age: 30,
      lat: 48.8566,
      lng: 2.3522,
    );

    final marseilleUser = PersonEntity(
      id: "marseille",
      nom: "Sardine",
      prenom: "Patrick",
      genre: "H",
      age: 40,
      lat: 43.2965,
      lng: 5.3698,
    );

    index.build([parisUser, marseilleUser]);

    // Query bucket around Paris (Radius 10km)
    final candidates = index.queryCandidates(48.8566, 2.3522, 10000);

    expect(candidates, contains(parisUser));
    expect(candidates, isNot(contains(marseilleUser)));
  });

  test('Performance with 1000 entities', () {
    final index = CellIndex<PersonEntity>();
    final entities = List.generate(1000, (i) {
      return PersonEntity(
        id: "user_$i",
        nom: "User",
        prenom: "$i",
        genre: "H",
        age: 20,
        lat: 48.0 + (i * 0.001),
        lng: 2.0 + (i * 0.001),
      );
    });

    final stopwatch = Stopwatch()..start();
    index.build(entities);
    // Query a subset
    final candidates = index.queryCandidates(48.5, 2.5, 10000);
    stopwatch.stop();

    expect(candidates.isNotEmpty, isTrue);
    expect(stopwatch.elapsedMilliseconds, lessThan(500));
  });
}
