import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coco/src/core/providers.dart';
import '../../domain/models/conversation_entity.dart';

final conversationsStreamProvider =
    StreamProvider.family<List<ConversationEntity>, String>((ref, userId) {
      final messagingService = ref.watch(messagingServiceProvider);
      return messagingService.getConversations(userId);
    });

final conversationControllerProvider = Provider<ConversationController>((ref) {
  return ConversationController(ref);
});

class ConversationController {
  final Ref ref;

  ConversationController(this.ref);

  Future<void> deleteConversation(String conversationId) async {
    final messagingService = ref.read(messagingServiceProvider);
    await messagingService.deleteConversation(conversationId);
  }

  Future<void> markAsRead({
    required String conversationId,
    required String userId,
  }) async {
    final messagingService = ref.read(messagingServiceProvider);
    await messagingService.markConversationAsRead(
      conversationId: conversationId,
      userId: userId,
    );
  }
}
