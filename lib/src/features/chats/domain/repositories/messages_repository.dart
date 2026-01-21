import '../models/message_entity.dart';

abstract class MessagesRepository {
  Stream<List<MessageEntity>> streamMessages(String conversationId);

  Future<List<MessageEntity>> getMessages({
    required String conversationId,
    int limit = 50,
    DateTime? before,
  });

  Future<String> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
    MessageType type = MessageType.text,
  });

  Future<void> markMessagesAsRead({
    required String conversationId,
    required String userId,
  });
}
