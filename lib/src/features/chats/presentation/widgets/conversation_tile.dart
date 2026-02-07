import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/conversation_entity.dart';

class ConversationTile extends StatelessWidget {
  final ConversationEntity conversation;
  final String currentUserId;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.currentUserId,
    required this.onTap,
    required this.onDelete,
  });

  Future<String> _getConversationName() async {
    if (conversation.title != null && conversation.title!.isNotEmpty) {
      return conversation.title!;
    }

    if (conversation.type == ConversationType.event) {
      if (conversation.eventId != null) {
        try {
          final eventDoc = await FirebaseFirestore.instance
              .collection('events')
              .doc(conversation.eventId)
              .get();
          if (eventDoc.exists) {
            return eventDoc.data()?['title'] ?? tr('chats.event_chat');
          }
        } catch (e) {
          return tr('chats.event_chat');
        }
      }
      return tr('chats.event_chat');
    } else if (conversation.type == ConversationType.slot) {
      return tr('chats.slot_chat');
    } else {
      final otherUserId = conversation.participantIds.firstWhere(
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

  @override
  Widget build(BuildContext context) {
    final unreadCount = conversation.unreadCount[currentUserId] ?? 0;

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: tr('chats.delete'),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD4913D).withValues(alpha: 0.2),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFFD4913D),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FutureBuilder<String>(
                            future: _getConversationName(),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data ?? '...',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ),
                        if (conversation.lastMessageTime != null)
                          Text(
                            _formatTime(conversation.lastMessageTime!),
                            style: TextStyle(
                              fontSize: 13,
                              color: unreadCount > 0
                                  ? const Color(0xFFD4913D)
                                  : Colors.grey[600],
                              fontWeight: unreadCount > 0
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.lastMessage ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: unreadCount > 0
                                  ? Colors.grey[900]
                                  : Colors.grey[600],
                              fontWeight: unreadCount > 0
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (unreadCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFD4913D),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Center(
                              child: Text(
                                unreadCount > 99 ? '99+' : '$unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
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
