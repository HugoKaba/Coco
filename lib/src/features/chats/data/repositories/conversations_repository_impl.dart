import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/conversation_entity.dart';
import '../../domain/repositories/conversations_repository.dart';

class ConversationsRepositoryImpl implements ConversationsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<ConversationEntity>> getConversations(String userId) {
    return _firestore
        .collection('conversations')
        .where('participantIds', arrayContains: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ConversationEntity.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<ConversationEntity?> getConversation(String conversationId) async {
    try {
      final doc = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .get();
      if (!doc.exists) return null;
      return ConversationEntity.fromFirestore(doc);
    } catch (e) {
      debugPrint('Error fetching conversation: $e');
      return null;
    }
  }

  @override
  Future<String> createConversation({
    required List<String> participantIds,
    required ConversationType type,
    String? eventId,
  }) async {
    try {
      final now = DateTime.now();
      final unreadCount = <String, int>{};
      for (final id in participantIds) {
        unreadCount[id] = 0;
      }

      final conversationData = {
        'participantIds': participantIds,
        'type': type == ConversationType.event ? 'event' : 'match',
        'eventId': eventId,
        'lastMessage': null,
        'lastMessageTime': null,
        'unreadCount': unreadCount,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      };

      final docRef = await _firestore
          .collection('conversations')
          .add(conversationData);
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating conversation: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateLastMessage({
    required String conversationId,
    required String message,
    required DateTime timestamp,
  }) async {
    try {
      await _firestore.collection('conversations').doc(conversationId).update({
        'lastMessage': message,
        'lastMessageTime': Timestamp.fromDate(timestamp),
        'updatedAt': Timestamp.fromDate(timestamp),
      });
    } catch (e) {
      debugPrint('Error updating last message: $e');
    }
  }

  @override
  Future<void> markAsRead({
    required String conversationId,
    required String userId,
  }) async {
    try {
      await _firestore.collection('conversations').doc(conversationId).update({
        'unreadCount.$userId': 0,
      });
    } catch (e) {
      debugPrint('Error marking as read: $e');
    }
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    try {
      await _firestore.collection('conversations').doc(conversationId).delete();
    } catch (e) {
      debugPrint('Error deleting conversation: $e');
    }
  }

  @override
  Future<void> addParticipant({
    required String conversationId,
    required String userId,
  }) async {
    try {
      await _firestore.collection('conversations').doc(conversationId).update({
        'participantIds': FieldValue.arrayUnion([userId]),
        'unreadCount.$userId': 0,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error adding participant: $e');
    }
  }
}
