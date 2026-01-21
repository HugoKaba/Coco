import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/models/conversation_entity.dart';
import 'conversation_name_helper.dart';

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
        child: Padding(
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
                    _buildHeader(unreadCount),
                    const SizedBox(height: 4),
                    _buildMessageRow(unreadCount),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(int unreadCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FutureBuilder<String>(
            future: ConversationNameHelper.getConversationName(
              conversation.type == ConversationType.event ? 'event' : 'match',
              conversation.participantIds,
              currentUserId,
              conversation.eventId,
            ),
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
            ConversationNameHelper.formatTime(conversation.lastMessageTime!),
            style: TextStyle(
              fontSize: 13,
              color: unreadCount > 0
                  ? const Color(0xFFD4913D)
                  : Colors.grey[600],
              fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
      ],
    );
  }

  Widget _buildMessageRow(int unreadCount) {
    return Row(
      children: [
        Expanded(
          child: Text(
            conversation.lastMessage ?? '',
            style: TextStyle(
              fontSize: 14,
              color: unreadCount > 0 ? Colors.grey[900] : Colors.grey[600],
              fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (unreadCount > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: const BoxDecoration(
              color: Color(0xFFD4913D),
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
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
    );
  }
}
