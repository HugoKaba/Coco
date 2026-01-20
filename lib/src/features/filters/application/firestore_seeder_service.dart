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
      prenom: 'Hugo',
      nom: 'Kaba',
      genre: 'M',
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
    String? prenom,
    String? nom,
    String? genre,
    bool isHero = false,
  }) async {
    final random = Random();
    final isMale = genre != null ? genre == 'M' : random.nextBool();
    final genPrenom =
        prenom ??
        (isMale
            ? SeederConstants.firstNamesM[random.nextInt(
                SeederConstants.firstNamesM.length,
              )]
            : SeederConstants.firstNamesF[random.nextInt(
                SeederConstants.firstNamesF.length,
              )]);
    final genNom =
        nom ??
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
      final levels = s['levels'] as List<String>;
      selectedSports.add({
        'sportName': s['name'],
        'level': levels[random.nextInt(levels.length)],
      });
    }

    final numDays = 1 + random.nextInt(4);
    final selectedDays = <String>{};
    while (selectedDays.length < numDays) {
      selectedDays.add(
        SeederConstants.days[random.nextInt(SeederConstants.days.length)],
      );
    }

    final data = {
      'id': id ?? '',
      'prenom': genPrenom,
      'nom': genNom,
      'age': 18 + random.nextInt(30),
      'genre': isMale ? 'M' : 'F',
      'dateDeNaissance': Timestamp.fromDate(DateTime(1990, 1, 1)),
      'ville': 'Paris',
      'latitude': lat,
      'longitude': lng,
      'coordonnees': geoLoc.data,
      'frequence_entrainement': 1 + random.nextInt(6),
      'objectif_sportif': [
        'Loisir',
        'Compétition',
        'Perte de poids',
      ][random.nextInt(3)],
      'photo_profil': isHero
          ? 'https://randomuser.me/api/portraits/men/1.jpg'
          : 'https://randomuser.me/api/portraits/${isMale ? "men" : "women"}/${random.nextInt(99)}.jpg',
      'jours': selectedDays.toList(),
      'description': SeederConstants
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
