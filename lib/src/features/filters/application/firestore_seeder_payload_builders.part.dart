part of 'firestore_seeder_service.dart';

/// Noms d'associations sportives réalistes, regroupés par sport, pour que les
/// clubs seedés aient une identité cohérente avec leur discipline (plutôt qu'un
/// libellé générique « Club Tennis 1 »). Indexés modulo la longueur de la liste.
const Map<String, List<String>> _clubNamesBySport = {
  'tennis': [
    'Tennis Club de Paris',
    'Racing Club de France Tennis',
    'Stade Français Tennis',
    'TC Boulogne-Billancourt',
    'Paris Université Club Tennis',
    'ASPTT Paris Tennis',
    'Tennis Club du 16e',
    'CA Montrouge Tennis',
    'TC Vincennes',
    'US Créteil Tennis',
  ],
  'padel': [
    'Padel Club Paris',
    'All In Padel Paris',
    'Casa Padel Saint-Denis',
    'Urban Padel Bastille',
    'Padel Attitude Montreuil',
    'Winners Padel Paris',
    '4Padel Paris',
    'Set Padel Club',
    'Padel Riverside Paris',
    'Smash Padel Nation',
  ],
  'football': [
    'Paris FC',
    'Red Star FC',
    'AS Paris 15',
    'US Ivry Football',
    'FC Montmartre',
    'Racing Club de Paris',
    'CA Paris Football',
    'Stade Ouest Parisien',
    'Espérance Paris 19',
    'Olympique de Pantin',
  ],
  'badminton': [
    'Badminton Club de Paris',
    'USM Malakoff Badminton',
    'BC Boulogne',
    'PUC Badminton',
    'Volant Parisien',
    "Bad'Nation Paris",
    'ASPTT Paris Badminton',
    'Smash Club Vincennes',
    'BC Montreuil',
    'Aile de Paris Badminton',
  ],
};

/// Rues parisiennes plausibles pour donner une adresse crédible à chaque club.
const List<String> _clubStreets = [
  '12 rue de la Roquette',
  '8 avenue de la République',
  '25 boulevard Voltaire',
  '3 rue du Faubourg Saint-Antoine',
  '17 avenue Daumesnil',
  '42 rue de Charonne',
  '6 boulevard de Ménilmontant',
  '19 rue Oberkampf',
  '31 avenue Ledru-Rollin',
  '5 rue de la Fontaine au Roi',
];

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
    final names = _clubNamesBySport[sportKey] ?? const [];
    final clubName = names.isNotEmpty
        ? names[i % names.length]
        : 'Club $sportLabel ${i + 1}';
    final emailSlug = clubName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '');
    final address = _clubStreets[i % _clubStreets.length];
    return {
      'id': clubId,
      'ownerId': FirestoreSeederService.myUserId,
      'name': clubName,
      'description':
          '$clubName, club de $sportLabel au cœur de Paris, ouvert à tous les niveaux.',
      'address': address,
      'city': 'Paris',
      'lat': lat,
      'lng': lng,
      'geopoint': GeoPoint(lat, lng),
      'activities': activities,
      'contactEmail': 'contact@$emailSlug.fr',
      'contactPhone': '010203040$i',
      'logoUrl':
          'https://api.dicebear.com/7.x/initials/png?seed=${Uri.encodeComponent(clubName)}',
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
