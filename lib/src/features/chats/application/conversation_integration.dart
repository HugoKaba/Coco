import 'package:coco/src/core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConversationIntegration {
  static Future<void> createMatchConversation({
    required Ref ref,
    required String userA,
    required String userB,
  }) async {
    final messagingService = ref.read(messagingServiceProvider);
    await messagingService.createMatchConversation(userA: userA, userB: userB);
  }

  static Future<void> createOrUpdateEventConversation({
    required Ref ref,
    required String eventId,
    required List<String> participantIds,
  }) async {
    final messagingService = ref.read(messagingServiceProvider);
    await messagingService.createEventConversation(
      eventId: eventId,
      participantIds: participantIds,
    );
  }

  static Future<void> addUserToEventConversation({
    required Ref ref,
    required String conversationId,
    required String userId,
  }) async {
    final messagingService = ref.read(messagingServiceProvider);
    await messagingService.addUserToEventConversation(
      conversationId: conversationId,
      userId: userId,
    );
  }
}
