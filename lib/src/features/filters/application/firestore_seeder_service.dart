import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'seeder_constants.dart';

class FirestoreSeederService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String myUserId = 'leJAn69mcRcKIHKNmT46UtEDGNu1';

  Future<void> seedUsers() async {
    await _deleteCollection('users_test');
    await _createUser(
      id: myUserId,
      firstName: 'Hugo',
      lastName: 'Kaba',
      gender: 'M',
      isHero: true,
    );

    final List<String> createdIds = [];
    for (int i = 0; i < 99; i++) {
      createdIds.add(await _createUser());
    }

    final potentialLikers = List.of(createdIds)..shuffle();
    for (int i = 0; i < 5; i++) {
      final fromId = potentialLikers[i];
      await _firestore
          .collection('users_test')
          .doc(fromId)
          .collection('swipes')
          .doc(myUserId)
          .set({
            'from': fromId,
            'to': myUserId,
            'type': 'like',
            'timestamp': FieldValue.serverTimestamp(),
          });
    }
  }

  Future<void> _deleteCollection(String path) async {
    final batch = _firestore.batch();
    final snapshot = await _firestore.collection(path).limit(500).get();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<String> _createUser({
    String? id,
    String? firstName,
    String? lastName,
    String? gender,
    bool isHero = false,
  }) async {
    final random = Random();
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

    final numSports = 1 + random.nextInt(3);
    final selectedSports = <Map<String, dynamic>>[];
    final shuffledSports = List.of(SeederConstants.sports)..shuffle();
    for (int i = 0; i < numSports; i++) {
      final s = shuffledSports[i];
      final levelIds = (s['levels'] as List).cast<int>();
      selectedSports.add({
        'sportId': s['id'],
        'levelId': levelIds[random.nextInt(levelIds.length)],
      });
    }

    final numDays = 1 + random.nextInt(4);
    final selectedDays = <int>{};
    while (selectedDays.length < numDays) {
      selectedDays.add(
        SeederConstants.days[random.nextInt(SeederConstants.days.length)],
      );
    }

    final data = {
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

    final docRef = id != null
        ? _firestore.collection('users_test').doc(id)
        : _firestore.collection('users_test').doc();
    final newId = docRef.id;
    await docRef.set(data..['id'] = newId);
    return newId;
  }
}
