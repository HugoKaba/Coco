part of 'firestore_seeder_service.dart';

Future<void> _seedClubsAndSlots(FirestoreSeederService s) async {
  final random = Random();
  await s._deleteCollection('clubs');
  await s._deleteCollection('slots');
  final sports = ClubSportCatalog.sports;

  for (int i = 0; i < 10; i++) {
    final sport = sports[random.nextInt(sports.length)];
    final lat = 48.8566 + (random.nextDouble() - 0.5) * 0.1;
    final lng = 2.3522 + (random.nextDouble() - 0.5) * 0.1;
    final clubRef = s._firestore.collection('clubs').doc();
    await clubRef.set(
      s._clubPayload(clubRef.id, sport.key, i, lat, lng, random),
    );
    await s._createSlotsForClub(clubRef.id, sport.key, random);
  }

  await _seedEvents(s);
}

/// Types d'événements réalistes pour composer des titres cohérents avec le
/// sport (« Tournoi de Tennis », « Match amical de Football »…).
const List<String> _eventTypes = [
  'Tournoi',
  'Match amical',
  'Stage découverte',
  'Rencontre',
  'Open',
  'Challenge',
  'Initiation',
  'Championnat',
];

Future<void> _seedEvents(FirestoreSeederService s) async {
  final random = Random();
  // Nettoyage préalable : sinon les re-seeds s'accumulent et les événements
  // créés à la main (ex. « test ») restent mêlés aux données de démo.
  await s._deleteCollection('events');
  final clubsSnapshot = await s._firestore.collection('clubs').get();
  if (clubsSnapshot.docs.isEmpty) return;

  for (int i = 0; i < 10; i++) {
    final club = clubsSnapshot.docs[random.nextInt(clubsSnapshot.docs.length)]
        .data();
    final rawActivities = club['activities'];
    final sport = rawActivities is List && rawActivities.isNotEmpty
        ? ClubSportCatalog.labelFor(rawActivities.first.toString())
        : 'Sport';
    final eventRef = s._firestore.collection('events').doc();
    final title = '${_eventTypes[i % _eventTypes.length]} de $sport';
    final eventDate = DateTime.now().add(
      Duration(days: 2 + random.nextInt(28), hours: 14 + random.nextInt(6)),
    );
    await eventRef.set(
      s._eventPayload(eventRef.id, title, sport, club, eventDate, random),
    );
    await s._createConversation(
      type: 'event',
      title: title,
      key: 'eventId',
      value: eventRef.id,
    );
  }
}
