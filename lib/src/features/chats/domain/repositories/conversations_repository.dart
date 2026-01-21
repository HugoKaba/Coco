import '../models/conversation_entity.dart';

abstract class ConversationsRepository {
  Stream<List<ConversationEntity>> getConversations(String userId);

  Future<ConversationEntity?> getConversation(String conversationId);

  Future<String> createConversation({
    required List<String> participantIds,
    required ConversationType type,
    String? eventId,
  });

  Future<void> updateLastMessage({
    required String conversationId,
    required String message,
    required DateTime timestamp,
  });

  Future<void> markAsRead({
    required String conversationId,
    required String userId,
  });

  Future<void> deleteConversation(String conversationId);

  Future<void> addParticipant({
    required String conversationId,
    required String userId,
  });
}
