import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/conversation_entity.dart';

part 'conversation_tile_resolver.part.dart';
part 'conversation_tile_badge.part.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.currentUserId,
    required this.onTap,
    required this.onDelete,
  });
  final ConversationEntity conversation;
  final String currentUserId;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final unread = conversation.unreadCount[currentUserId] ?? 0;
    final cs = Theme.of(context).colorScheme;
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
                  color: AppColors.brand.withValues(alpha: 0.2),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.brand,
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
                            future: resolveConversationName(
                              conversation,
                              currentUserId,
                            ),
                            builder: (_, snap) => Text(
                              snap.data ?? '...',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        if (conversation.lastMessageTime != null)
                          Text(
                            formatConversationTime(
                              conversation.lastMessageTime!,
                            ),
                            style: TextStyle(
                              fontSize: 13,
                              color: unread > 0
                                  ? AppColors.brand
                                  : cs.onSurfaceVariant,
                              fontWeight: unread > 0
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: unread > 0
                                  ? cs.onSurface
                                  : cs.onSurfaceVariant,
                              fontWeight: unread > 0
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (unread > 0) ...[
                          const SizedBox(width: 8),
                          _conversationBadge(unread),
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
}
