import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/core/providers.dart';
import 'controllers/conversations_controller.dart';
import 'widgets/conversation_tile.dart';
import 'widgets/conversation_empty_state.dart';
import 'pages/chat_screen.dart';

class ChatsPage extends ConsumerWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text(tr('chats.title'))),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return Center(child: Text('chats.not_authenticated'.tr()));
          }

          final conversationsStream = ref.watch(
            conversationsStreamProvider(user.uid),
          );

          return conversationsStream.when(
            data: (conversations) {
              if (conversations.isEmpty) {
                return const ConversationEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(conversationsStreamProvider(user.uid));
                },
                color: AppColors.brand,
                child: ListView.separated(
                  itemCount: conversations.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                    indent: 84,
                  ),
                  itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    return ConversationTile(
                      conversation: conversation,
                      currentUserId: user.uid,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              conversationId: conversation.id,
                              currentUserId: user.uid,
                            ),
                          ),
                        );
                      },
                      onDelete: () async {
                        final controller = ref.read(
                          conversationControllerProvider,
                        );
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(tr('chats.delete')),
                            content: Text(tr('chats.delete_confirm')),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text(tr('common.cancel')),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: Text(tr('chats.delete')),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await controller.deleteConversation(conversation.id);
                        }
                      },
                    );
                  },
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.brand),
              ),
            ),
            error: (e, s) => Center(
              child: Text(tr('chats.error_prefix', namedArgs: {'error': e.toString()})),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(
          child: Text(tr('chats.error_prefix', namedArgs: {'error': e.toString()})),
        ),
      ),
    );
  }
}
