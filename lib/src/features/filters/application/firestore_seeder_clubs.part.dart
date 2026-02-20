part of 'firestore_seeder_service.dart';

Future<void> _seedClubsAndSlots(FirestoreSeederService s) async {
  final random = Random();
  await s._deleteCollection('clubs');
  await s._deleteCollection('slots');
  final sports = ['Tennis', 'Padel', 'Football', 'Badminton'];

  for (int i = 0; i < 10; i++) {
    final sport = sports[random.nextInt(sports.length)];
    final lat = 48.8566 + (random.nextDouble() - 0.5) * 0.1;
    final lng = 2.3522 + (random.nextDouble() - 0.5) * 0.1;
    final clubRef = s._firestore.collection('clubs').doc();
    await clubRef.set(s._clubPayload(clubRef.id, sport, i, lat, lng, random));
    await s._createSlotsForClub(clubRef.id, sport, random);
  }

  await _seedEvents(s);
}

Future<void> _seedEvents(FirestoreSeederService s) async {
  final random = Random();
  final clubsSnapshot = await s._firestore.collection('clubs').get();
  if (clubsSnapshot.docs.isEmpty) return;

  for (int i = 0; i < 10; i++) {
    final club = clubsSnapshot.docs[random.nextInt(clubsSnapshot.docs.length)]
        .data();
    final sport = club['sportType'] ?? 'Sport';
    final eventRef = s._firestore.collection('events').doc();
    final title = 'Grand Tournoi $sport #${i + 1}';
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
