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

  Future<void> seedClubsAndSlots() async {
    final random = Random();

    // 1. Clear existing data (optional, but cleaner)
    await _deleteCollection('clubs');
    await _deleteCollection('slots');
    // careful deleting conversations if mixes matches

    final sports = ['Tennis', 'Padel', 'Football', 'Badminton'];

    for (int i = 0; i < 10; i++) {
      final sport = sports[random.nextInt(sports.length)];
      final lat = 48.8566 + (random.nextDouble() - 0.5) * 0.1;
      final lng = 2.3522 + (random.nextDouble() - 0.5) * 0.1;

      // Create Club
      final clubRef = _firestore.collection('clubs').doc();
      final clubId = clubRef.id;

      await clubRef.set({
        'id': clubId,
        'ownerId': myUserId, // Assign to me so I can manage
        'name': 'Club $sport ${i + 1}',
        'description': 'Un super club de $sport au cœur de Paris.',
        'address': 'Rue de Paris $i',
        'city': 'Paris',
        'lat': lat,
        'lng': lng,
        'geopoint': GeoPoint(lat, lng),
        'sportType': sport,
        'contactEmail': 'club$i@test.com',
        'contactPhone': '010203040$i',
        'logoUrl': 'https://api.dicebear.com/7.x/initials/png?seed=Club$i',
        'photoUrls': [
          'https://source.unsplash.com/random/800x600/?${sport.toLowerCase()}',
        ],
        'facilities': [sport, 'Douche', 'Parking'],
        'subscriptionType': 'premium',
        'subscriptionExpiresAt': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 365)),
        ),
        'isActive': true,
        'maxCapacity': 50 + random.nextInt(100),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'weeklyHours': {
          'Monday': {'isOpen': true, 'openTime': '09:00', 'closeTime': '22:00'},
          'Tuesday': {
            'isOpen': true,
            'openTime': '09:00',
            'closeTime': '22:00',
          },
          'Wednesday': {
            'isOpen': true,
            'openTime': '09:00',
            'closeTime': '22:00',
          },
          'Thursday': {
            'isOpen': true,
            'openTime': '09:00',
            'closeTime': '22:00',
          },
          'Friday': {'isOpen': true, 'openTime': '09:00', 'closeTime': '22:00'},
          'Saturday': {
            'isOpen': true,
            'openTime': '10:00',
            'closeTime': '20:00',
          },
          'Sunday': {'isOpen': false, 'openTime': null, 'closeTime': null},
        },
      });

      // Create Slots
      await _createSlotsForClub(clubId, sport, random);
    }

    await seedEvents();
  }

  Future<void> _createSlotsForClub(
    String clubId,
    String sport,
    Random random,
  ) async {
    for (int k = 0; k < 5; k++) {
      final slotRef = _firestore.collection('slots').doc();
      final slotId = slotRef.id;

      // Random time in next 7 days
      final today = DateTime.now();
      final slotDate = today.add(
        Duration(days: random.nextInt(7), hours: 9 + random.nextInt(10)),
      );
      final endTime = slotDate.add(const Duration(hours: 1));

      // We only create course or openPlay here, events are handled separately
      final type = k % 2 == 0 ? 'course' : 'openPlay';
      final title = k % 2 == 0 ? 'Cours $sport Débutant' : 'Jeu libre $sport';

      await slotRef.set({
        'id': slotId,
        'clubId': clubId,
        'type': type,
        'startTime': Timestamp.fromDate(slotDate),
        'endTime': Timestamp.fromDate(endTime),
        'maxParticipants': 4,
        'participants': [],
        'level': 'beginner',
        'ageGroup': '18-35',
        'courtNumber': random.nextInt(5) + 1,
        'isRecurring': false,
        'createdAt': FieldValue.serverTimestamp(),
        'price': 10 + random.nextInt(20).toDouble(),
      });

      // Create Chat for this Slot
      await _createChatForSlot(slotId, title);
    }
  }

  Future<void> seedEvents() async {
    final random = Random();
    final clubsSnapshot = await _firestore.collection('clubs').get();
    if (clubsSnapshot.docs.isEmpty) return;

    final clubs = clubsSnapshot.docs;

    // Create ~10 events
    for (int i = 0; i < 10; i++) {
      final clubDoc = clubs[random.nextInt(clubs.length)];
      final clubData = clubDoc.data();
      final sport = clubData['sportType'] ?? 'Sport';

      final eventRef = _firestore.collection('events').doc();
      final eventId = eventRef.id;

      final today = DateTime.now();
      // Events in next 30 days
      final eventDate = today.add(
        Duration(
          days: 2 + random.nextInt(28),
          hours: 14 + random.nextInt(6),
        ), // Afternoon/Evening
      );

      final title = 'Grand Tournoi $sport #${i + 1}';

      await eventRef.set({
        'id': eventId,
        'creatorId': myUserId,
        'title': title,
        'description':
            'Un grand événement convivial pour tous les passionnés de $sport !',
        'date': Timestamp.fromDate(eventDate),
        'locationName': '${clubData['address']}, ${clubData['city']}',
        'lat': clubData['lat'],
        'lng': clubData['lng'],
        'maxPlaces': 20 + random.nextInt(30),
        'attendees': [],
        'sport': sport,
        'level': 'all',
        'price': 25.0,
        'imageUrl':
            'https://source.unsplash.com/random/800x600/?${sport.toLowerCase()}',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // EventsRepository creates conversation with type 'event' and eventId.
      final chatRef = _firestore.collection('conversations').doc();
      await chatRef.set({
        'id': chatRef.id,
        'participantIds': [],
        'type': 'event',
        'eventId': eventId,
        'title': title,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'unreadCount': {},
      });
    }
  }

  Future<void> _createChatForSlot(String slotId, String title) async {
    final chatRef = _firestore.collection('conversations').doc();
    await chatRef.set({
      'id': chatRef.id,
      'participantIds': [],
      'type': 'slot',
      'slotId': slotId,
      'title': title,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'unreadCount': {},
    });
  }
}
