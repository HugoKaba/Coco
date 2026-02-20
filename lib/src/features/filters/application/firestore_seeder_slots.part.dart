part of 'firestore_seeder_service.dart';

extension _SeederSlots on FirestoreSeederService {
  Future<void> _createSlotsForClub(
    String clubId,
    String sport,
    Random random,
  ) async {
    for (int k = 0; k < 5; k++) {
      final slotRef = _firestore.collection('slots').doc();
      final slotDate = DateTime.now().add(
        Duration(days: random.nextInt(7), hours: 9 + random.nextInt(10)),
      );
      final type = k % 2 == 0 ? 'course' : 'openPlay';
      final title = k % 2 == 0 ? 'Cours $sport Débutant' : 'Jeu libre $sport';
      await slotRef.set({
        'id': slotRef.id,
        'clubId': clubId,
        'type': type,
        'startTime': Timestamp.fromDate(slotDate),
        'endTime': Timestamp.fromDate(slotDate.add(const Duration(hours: 1))),
        'maxParticipants': 4,
        'participants': [],
        'level': 'beginner',
        'ageGroup': '18-35',
        'courtNumber': random.nextInt(5) + 1,
        'isRecurring': false,
        'createdAt': FieldValue.serverTimestamp(),
        'price': 10 + random.nextInt(20).toDouble(),
      });
      await _createConversation(
        type: 'slot',
        title: title,
        key: 'slotId',
        value: slotRef.id,
      );
    }
  }
}
