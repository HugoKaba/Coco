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
            UserSport(sportName: s['sportName'] ?? '', level: s['level'] ?? ''),
          );
        }
      }
    }

    final personId = (e['id'] as String?)?.isNotEmpty == true
        ? e['id']
        : doc.id;
    return PersonEntity(
      id: personId,
      prenom: e['prenom'] ?? 'User',
      nom: e['nom'] ?? '',
      genre: e['genre'] ?? 'M',
      age: e['age'] ?? 25,
      lat: (e['latitude'] as num?)?.toDouble() ?? 0.0,
      lng: (e['longitude'] as num?)?.toDouble() ?? 0.0,
      metadata: {'city': e['city']},
      sports: userSports,
      availabilities: (e['jours'] as List?)?.cast<String>() ?? [],
      description: e['description'],
      profilePhotoUrl: e['profilePhotoUrl'],
      frequency: e['frequency'] ?? 0,
      objective: e['objective'] ?? 'Loisir',
    );
  }
}
