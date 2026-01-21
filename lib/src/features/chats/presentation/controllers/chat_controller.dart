import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coco/src/core/providers.dart';
import '../../domain/models/message_entity.dart';

final messagesStreamProvider =
    StreamProvider.family<List<MessageEntity>, String>((ref, conversationId) {
      final messagingService = ref.watch(messagingServiceProvider);
      return messagingService.getMessages(conversationId);
    });

final chatControllerProvider = Provider.family<ChatController, String>((
  ref,
  conversationId,
) {
  return ChatController(ref, conversationId);
});

class ChatController {
  final Ref ref;
  final String conversationId;

  ChatController(this.ref, this.conversationId);

  Future<void> sendMessage({
    required String senderId,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    final messagingService = ref.read(messagingServiceProvider);
    await messagingService.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      text: text.trim(),
    );
  }

  Future<void> markAsRead(String userId) async {
    final messagingService = ref.read(messagingServiceProvider);
    await messagingService.markConversationAsRead(
      conversationId: conversationId,
      userId: userId,
    );
  }
}
