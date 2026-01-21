import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/message_entity.dart';
import '../../domain/repositories/messages_repository.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<MessageEntity>> streamMessages(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageEntity.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<List<MessageEntity>> getMessages({
    required String conversationId,
    int limit = 50,
    DateTime? before,
  }) async {
    try {
      Query query = _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (before != null) {
        query = query.where(
          'timestamp',
          isLessThan: Timestamp.fromDate(before),
        );
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => MessageEntity.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('Error fetching messages: $e');
      return [];
    }
  }

  @override
  Future<String> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
    MessageType type = MessageType.text,
  }) async {
    try {
      final now = DateTime.now();
      final messageData = {
        'conversationId': conversationId,
        'senderId': senderId,
        'text': text,
        'timestamp': Timestamp.fromDate(now),
        'readBy': [senderId],
        'type': type == MessageType.system ? 'system' : 'text',
      };

      final docRef = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add(messageData);

      return docRef.id;
    } catch (e) {
      debugPrint('Error sending message: $e');
      rethrow;
    }
  }

  @override
  Future<void> markMessagesAsRead({
    required String conversationId,
    required String userId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .where(
            'readBy',
            whereNotIn: [
              [userId],
            ],
          )
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {
          'readBy': FieldValue.arrayUnion([userId]),
        });
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Error marking messages as read: $e');
    }
  }
}
