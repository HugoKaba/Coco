import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SwipeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

    // Create match document (could be in a top-level 'matches' collection)
    await _firestore.collection('matches').doc(matchId).set(matchData);
  }

  String _generateMatchId(String a, String b) {
    return a.compareTo(b) < 0 ? '${a}_$b' : '${b}_$a';
  }

  /// Fetch IDs of users that [userId] has already swiped on.
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
