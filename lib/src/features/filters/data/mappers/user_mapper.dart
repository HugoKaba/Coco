import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/person_entity.dart';

class UserMapper {
  static PersonEntity fromFirestore(DocumentSnapshot doc) {
    final e = doc.data() as Map<String, dynamic>;
    final rawSports = (e['userSports'] as List?) ?? [];
    final List<UserSport> userSports = [];

    if (rawSports.isNotEmpty) {
      for (final s in rawSports) {
        if (s is Map) {
          userSports.add(
            UserSport(
              sportId: (s['sportId'] as num?)?.toInt() ?? 0,
              levelId: (s['levelId'] as num?)?.toInt() ?? 0,
            ),
          );
        }
      }
    }

    final personId = (e['id'] as String?)?.isNotEmpty == true
        ? e['id']
        : doc.id;

    final days =
        (e['days'] as List?)?.map((e) => (e as num).toInt()).toList() ?? [];

    return PersonEntity(
      id: personId,
      firstName: e['firstName'] ?? 'User',
      lastName: e['lastName'] ?? '',
      gender: e['gender'] ?? 'M',
      age: e['age'] ?? 25,
      lat: (e['latitude'] as num?)?.toDouble() ?? 0.0,
      lng: (e['longitude'] as num?)?.toDouble() ?? 0.0,
      metadata: {'city': e['city']},
      sports: userSports,
      availabilities: days,
      bio: e['bio'],
      profilePhotoUrl: e['profilePhoto'] ?? e['profilePhotoUrl'],
      frequency: e['trainingFrequency'] ?? 0,
      objective: e['sportsGoal'] ?? 'Loisir',
    );
  }
}
