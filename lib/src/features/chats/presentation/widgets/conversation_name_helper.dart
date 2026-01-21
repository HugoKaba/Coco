import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

class ConversationNameHelper {
  static Future<String> getConversationName(
    String conversationType,
    List<String> participantIds,
    String currentUserId,
    String? eventId,
  ) async {
    if (conversationType == 'event') {
      if (eventId != null) {
        try {
          final eventDoc = await FirebaseFirestore.instance
              .collection('events')
              .doc(eventId)
              .get();
          if (eventDoc.exists) {
            return eventDoc.data()?['title'] ?? tr('chats.event_chat');
          }
        } catch (e) {
          return tr('chats.event_chat');
        }
      }
      return tr('chats.event_chat');
    } else {
      final otherUserId = participantIds.firstWhere(
        (id) => id != currentUserId,
        orElse: () => '',
      );
      if (otherUserId.isEmpty) return tr('chats.match_chat');

      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users_test')
            .doc(otherUserId)
            .get();
        if (userDoc.exists) {
          final data = userDoc.data();
          final firstName = data?['firstName'] ?? '';
          final lastName = data?['lastName'] ?? '';
          if (firstName.isNotEmpty) {
            return '$firstName ${lastName.isNotEmpty ? lastName[0] + '.' : ''}';
          }
          return data?['username'] ?? tr('chats.match_chat');
        }
      } catch (e) {
        return tr('chats.match_chat');
      }
      return tr('chats.match_chat');
    }
  }

  static String formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return DateFormat('HH:mm').format(time);
    } else if (messageDate == yesterday) {
      return tr('chats.yesterday');
    } else if (now.difference(time).inDays < 7) {
      return DateFormat('EEE').format(time);
    } else {
      return DateFormat('dd/MM/yy').format(time);
    }
  }
}
