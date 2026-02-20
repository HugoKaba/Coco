part of 'conversation_tile.dart';

Future<String> resolveConversationName(
  ConversationEntity conversation,
  String currentUserId,
) async {
  if (conversation.title != null && conversation.title!.isNotEmpty) {
    return conversation.title!;
  }
  if (conversation.type == ConversationType.event) {
    return _eventTitle(conversation.eventId);
  }
  if (conversation.type == ConversationType.slot) return tr('chats.slot_chat');

  final other = conversation.participantIds.firstWhere(
    (id) => id != currentUserId,
    orElse: () => '',
  );
  if (other.isEmpty) return tr('chats.match_chat');
  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('users_test')
        .doc(other)
        .get();
    if (!userDoc.exists) return tr('chats.match_chat');
    final data = userDoc.data();
    final first = data?['firstName'] ?? '';
    final last = data?['lastName'] ?? '';
    if (first.isNotEmpty) {
      return '$first ${last.isNotEmpty ? last[0] + '.' : ''}';
    }
    return data?['username'] ?? tr('chats.match_chat');
  } catch (_) {
    return tr('chats.match_chat');
  }
}

Future<String> _eventTitle(String? eventId) async {
  if (eventId == null) return tr('chats.event_chat');
  try {
    final eventDoc = await FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .get();
    if (eventDoc.exists) {
      return eventDoc.data()?['title'] ?? tr('chats.event_chat');
    }
    return tr('chats.event_chat');
  } catch (_) {
    return tr('chats.event_chat');
  }
}

String formatConversationTime(DateTime time) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final d = DateTime(time.year, time.month, time.day);
  if (d == today) return DateFormat('HH:mm').format(time);
  if (d == yesterday) return tr('chats.yesterday');
  if (now.difference(time).inDays < 7) return DateFormat('EEE').format(time);
  return DateFormat('dd/MM/yy').format(time);
}
