part of 'firestore_seeder_service.dart';

extension _SeederPayloadBuilders on FirestoreSeederService {
  Map<String, dynamic> _clubPayload(
    String clubId,
    String sport,
    int i,
    double lat,
    double lng,
    Random random,
  ) {
    final sportLabel = ClubSportCatalog.labelFor(sport);
    final sportKey = ClubSportCatalog.normalizeKey(sport);
    final extraActivities =
        ClubSportCatalog.sports.where((s) => s.key != sportKey).toList()
          ..shuffle(random);
    final activities = ClubSportCatalog.ensureKnownKeys([
      sportKey,
      if (random.nextBool()) extraActivities.first.key,
    ]);
    return {
      'id': clubId,
      'ownerId': FirestoreSeederService.myUserId,
      'name': 'Club $sportLabel ${i + 1}',
      'description': 'Un super club de $sportLabel au coeur de Paris.',
      'address': 'Rue de Paris $i',
      'city': 'Paris',
      'lat': lat,
      'lng': lng,
      'geopoint': GeoPoint(lat, lng),
      'activities': activities,
      'contactEmail': 'club$i@test.com',
      'contactPhone': '010203040$i',
      'logoUrl': 'https://api.dicebear.com/7.x/initials/png?seed=Club$i',
      'photoUrls': ['https://source.unsplash.com/random/800x600/?$sportKey'],
      'facilities': [
        ...activities.map(ClubSportCatalog.labelFor),
        'Douche',
        'Parking',
      ],
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
        'Tuesday': {'isOpen': true, 'openTime': '09:00', 'closeTime': '22:00'},
        'Wednesday': {
          'isOpen': true,
          'openTime': '09:00',
          'closeTime': '22:00',
        },
        'Thursday': {'isOpen': true, 'openTime': '09:00', 'closeTime': '22:00'},
        'Friday': {'isOpen': true, 'openTime': '09:00', 'closeTime': '22:00'},
        'Saturday': {'isOpen': true, 'openTime': '10:00', 'closeTime': '20:00'},
        'Sunday': {'isOpen': false, 'openTime': null, 'closeTime': null},
      },
    };
  }

  Map<String, dynamic> _eventPayload(
    String eventId,
    String title,
    dynamic sport,
    Map<String, dynamic> club,
    DateTime eventDate,
    Random random,
  ) => {
    'id': eventId,
    'creatorId': FirestoreSeederService.myUserId,
    'title': title,
    'description':
        'Un grand evenement convivial pour tous les passionnes de $sport !',
    'date': Timestamp.fromDate(eventDate),
    'locationName': '${club['address']}, ${club['city']}',
    'lat': club['lat'],
    'lng': club['lng'],
    'maxPlaces': 20 + random.nextInt(30),
    'attendees': [],
    'sport': sport,
    'level': 'all',
    'price': 25.0,
    'imageUrl':
        'https://source.unsplash.com/random/800x600/?${sport.toString().toLowerCase()}',
    'createdAt': FieldValue.serverTimestamp(),
  };

  Future<void> _createConversation({
    required String type,
    required String key,
    required String value,
    required String title,
  }) async {
    final chatRef = _firestore.collection('conversations').doc();
    await chatRef.set({
      'id': chatRef.id,
      'participantIds': [],
      'type': type,
      key: value,
      'title': title,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'unreadCount': {},
    });
  }
}
