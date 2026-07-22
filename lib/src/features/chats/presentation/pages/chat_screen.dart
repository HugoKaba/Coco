import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/chat_controller.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input_field.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.currentUserId,
  });
  final String conversationId;
  final String currentUserId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref
          .read(chatControllerProvider(widget.conversationId))
          .markAsRead(widget.currentUserId),
    );
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesStreamProvider(widget.conversationId));
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('conversations')
              .doc(widget.conversationId)
              .snapshots(),
          builder: (_, snap) => _title(snap),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.when(
              data: (items) => ListView.builder(
                controller: _scroll,
                reverse: true,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                itemCount: items.length,
                itemBuilder: (_, i) => MessageBubble(
                  message: items[i],
                  isMe: items[i].senderId == widget.currentUserId,
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.brand),
                ),
              ),
              error: (e, _) => Center(
                child: Text(tr('chats.error_prefix', namedArgs: {'error': e.toString()})),
              ),
            ),
          ),
          MessageInputField(
            onSend: (text) async {
              await ref
                  .read(chatControllerProvider(widget.conversationId))
                  .sendMessage(senderId: widget.currentUserId, text: text);
              if (_scroll.hasClients) {
                _scroll.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _title(AsyncSnapshot<DocumentSnapshot> snap) {
    final style = TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: AppFontSize.lg,
      fontWeight: FontWeight.w600,
    );
    if (!snap.hasData) return Text(tr('chats.title'), style: style);
    final data = snap.data?.data() as Map<String, dynamic>?;
    final title = data?['title'] as String?;
    if (title != null && title.isNotEmpty) return Text(title, style: style);
    final participants = List<String>.from(data?['participantIds'] ?? []);
    final otherUserId = participants.firstWhere(
      (id) => id != widget.currentUserId,
      orElse: () => '',
    );
    if (otherUserId.isEmpty) return Text(tr('chats.title'), style: style);
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users_test')
          .doc(otherUserId)
          .snapshots(),
      builder: (_, userSnap) {
        if (!userSnap.hasData) return const Text('...');
        final u = userSnap.data?.data() as Map<String, dynamic>?;
        final first = u?['firstName'] ?? '';
        final last = u?['lastName'] ?? '';
        final username = u?['username'] ?? '';
        return Text(
          first.isNotEmpty
              ? '$first ${last.isNotEmpty ? last[0] + '.' : ''}'
              : username,
          style: style,
        );
      },
    );
  }
}
