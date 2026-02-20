part of 'firestore_seeder_service.dart';

extension _SeederPayloadBuilders on FirestoreSeederService {
  Map<String, dynamic> _clubPayload(
    String clubId,
    String sport,
    int i,
    double lat,
    double lng,
    Random random,
  ) => {
    'id': clubId,
    'ownerId': FirestoreSeederService.myUserId,
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
      'Tuesday': {'isOpen': true, 'openTime': '09:00', 'closeTime': '22:00'},
      'Wednesday': {'isOpen': true, 'openTime': '09:00', 'closeTime': '22:00'},
      'Thursday': {'isOpen': true, 'openTime': '09:00', 'closeTime': '22:00'},
      'Friday': {'isOpen': true, 'openTime': '09:00', 'closeTime': '22:00'},
      'Saturday': {'isOpen': true, 'openTime': '10:00', 'closeTime': '20:00'},
      'Sunday': {'isOpen': false, 'openTime': null, 'closeTime': null},
    },
  };

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
        'Un grand événement convivial pour tous les passionnés de $sport !',
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
