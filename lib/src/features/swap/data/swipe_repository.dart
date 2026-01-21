import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:coco/src/features/chats/domain/repositories/conversations_repository.dart';
import 'package:coco/src/features/chats/data/repositories/conversations_repository_impl.dart';
import 'package:coco/src/features/chats/domain/models/conversation_entity.dart';

class SwipeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ConversationsRepository _conversationsRepo =
      ConversationsRepositoryImpl();

  Future<bool> recordSwipe({
    required String userId,
    required String targetId,
    required bool isLike,
  }) async {
    if (userId.isEmpty || targetId.isEmpty) {
      debugPrint(
        'Error: Attempted swipe with empty ID. User: "$userId", Target: "$targetId"',
      );
      return false;
    }
    try {
      final swipeData = {
        'from': userId,
        'to': targetId,
        'type': isLike ? 'like' : 'nope',
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users_test')
          .doc(userId)
          .collection('swipes')
          .doc(targetId)
          .set(swipeData);

      if (!isLike) return false;

      final targetSwipeDoc = await _firestore
          .collection('users_test')
          .doc(targetId)
          .collection('swipes')
          .doc(userId)
          .get();

      if (targetSwipeDoc.exists && targetSwipeDoc.data()?['type'] == 'like') {
        await _createMatch(userId, targetId);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error recording swipe: $e');
      return false;
    }
  }

  Future<void> _createMatch(String userA, String userB) async {
    final matchId = _generateMatchId(userA, userB);
    final matchData = {
      'users': [userA, userB],
      'timestamp': FieldValue.serverTimestamp(),
      'lastMessage': null,
    };

    await _firestore.collection('matches').doc(matchId).set(matchData);

    try {
      await _conversationsRepo.createConversation(
        participantIds: [userA, userB],
        type: ConversationType.match,
      );
    } catch (e) {
      debugPrint('Error creating conversation: $e');
    }
  }

  String _generateMatchId(String a, String b) {
    return a.compareTo(b) < 0 ? '${a}_$b' : '${b}_$a';
  }

  Future<List<String>> getSwipedUserIds(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users_test')
          .doc(userId)
          .collection('swipes')
          .get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      debugPrint('Error fetching swipes: $e');
      return [];
    }
  }
}
