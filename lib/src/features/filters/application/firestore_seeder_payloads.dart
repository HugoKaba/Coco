import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import 'seeder_constants.dart';

class SeederPayloads {
  static Map<String, dynamic> user({
    required Random random,
    required bool isHero,
    String? id,
    String? firstName,
    String? lastName,
    String? gender,
  }) {
    final isMale = gender != null ? gender == 'M' : random.nextBool();
    final genFirstName =
        firstName ??
        (isMale
            ? SeederConstants.firstNamesM[random.nextInt(
                SeederConstants.firstNamesM.length,
              )]
            : SeederConstants.firstNamesF[random.nextInt(
                SeederConstants.firstNamesF.length,
              )]);
    final genLastName =
        lastName ??
        SeederConstants.lastNames[random.nextInt(
          SeederConstants.lastNames.length,
        )];

    final lat = 48.8566 + (random.nextDouble() - 0.5) * 0.5;
    final lng = 2.3522 + (random.nextDouble() - 0.5) * 0.5;
    final geoLoc = GeoFirePoint(GeoPoint(lat, lng));

    final selectedSports = <Map<String, dynamic>>[];
    final shuffledSports = List.of(SeederConstants.sports)..shuffle();
    for (int i = 0; i < 1 + random.nextInt(3); i++) {
      final s = shuffledSports[i];
      final levelIds = (s['levels'] as List).cast<int>();
      selectedSports.add({
        'sportId': s['id'],
        'levelId': levelIds[random.nextInt(levelIds.length)],
      });
    }

    final selectedDays = <int>{};
    while (selectedDays.length < 1 + random.nextInt(4)) {
      selectedDays.add(
        SeederConstants.days[random.nextInt(SeederConstants.days.length)],
      );
    }

    return {
      'id': id ?? '',
      'firstName': genFirstName,
      'lastName': genLastName,
      'age': 18 + random.nextInt(30),
      'gender': isMale ? 'M' : 'F',
      'birthDate': Timestamp.fromDate(DateTime(1990, 1, 1)),
      'city': 'Paris',
      'latitude': lat,
      'longitude': lng,
      'coordinates': geoLoc.data,
      'trainingFrequency': 1 + random.nextInt(6),
      'sportsGoal': [
        'Loisir',
        'Compétition',
        'Perte de poids',
      ][random.nextInt(3)],
      'profilePhoto': isHero
          ? 'https://randomuser.me/api/portraits/men/1.jpg'
          : 'https://randomuser.me/api/portraits/${isMale ? "men" : "women"}/${random.nextInt(99)}.jpg',
      'days': selectedDays.toList(),
      'bio': SeederConstants
          .descriptions[random.nextInt(SeederConstants.descriptions.length)],
      'userSports': selectedSports,
    };
  }
}
