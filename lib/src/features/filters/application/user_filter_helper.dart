import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/mappers/user_mapper.dart';
import '../domain/models/person_entity.dart';

class UserFilterHelper {
  static List<PersonEntity> filterUsers(
    List<QueryDocumentSnapshot> docs,
    String userId,
    Set<String> swipedIds,
  ) {
    if (docs.isEmpty) return [];

    return docs.map((doc) => UserMapper.fromFirestore(doc)).where((u) {
      final isSwiped = swipedIds.contains(u.id);
      final isCurrentUser = u.id == userId;
      return !isSwiped && !isCurrentUser;
    }).toList();
  }
}
