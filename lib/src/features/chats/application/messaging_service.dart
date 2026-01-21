import '../domain/models/conversation_entity.dart';
import '../domain/models/message_entity.dart';
import '../domain/repositories/conversations_repository.dart';
import '../domain/repositories/messages_repository.dart';

class MessagingService {
  final ConversationsRepository _conversationsRepo;
  final MessagesRepository _messagesRepo;

  MessagingService(this._conversationsRepo, this._messagesRepo);

  Future<String> createMatchConversation({
    required String userA,
    required String userB,
  }) async {
    return await _conversationsRepo.createConversation(
      participantIds: [userA, userB],
      type: ConversationType.match,
    );
  }

  Future<String> createEventConversation({
    required String eventId,
    required List<String> participantIds,
  }) async {
    return await _conversationsRepo.createConversation(
      participantIds: participantIds,
      type: ConversationType.event,
      eventId: eventId,
    );
  }

  Future<void> addUserToEventConversation({
    required String conversationId,
    required String userId,
  }) async {
    await _conversationsRepo.addParticipant(
      conversationId: conversationId,
      userId: userId,
    );
  }

  Future<String> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    final messageId = await _messagesRepo.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      text: text,
    );

    await _conversationsRepo.updateLastMessage(
      conversationId: conversationId,
      message: text,
      timestamp: DateTime.now(),
    );

    await _incrementUnreadCounts(conversationId, senderId);

    return messageId;
  }

  Future<void> markConversationAsRead({
    required String conversationId,
    required String userId,
  }) async {
    await _messagesRepo.markMessagesAsRead(
      conversationId: conversationId,
      userId: userId,
    );
    await _conversationsRepo.markAsRead(
      conversationId: conversationId,
      userId: userId,
    );
  }

  Future<void> _incrementUnreadCounts(
    String conversationId,
    String senderId,
  ) async {
    final conversation = await _conversationsRepo.getConversation(
      conversationId,
    );
    if (conversation == null) return;

    final updatedUnreadCount = Map<String, int>.from(conversation.unreadCount);
    for (final participantId in conversation.participantIds) {
      if (participantId != senderId) {
        updatedUnreadCount[participantId] =
            (updatedUnreadCount[participantId] ?? 0) + 1;
      }
    }
  }

  Stream<List<ConversationEntity>> getConversations(String userId) {
    return _conversationsRepo.getConversations(userId);
  }

  Stream<List<MessageEntity>> getMessages(String conversationId) {
    return _messagesRepo.streamMessages(conversationId);
  }

  Future<void> deleteConversation(String conversationId) async {
    await _conversationsRepo.deleteConversation(conversationId);
  }
}
