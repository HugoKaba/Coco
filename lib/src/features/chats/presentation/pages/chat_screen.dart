import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/chat_controller.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input_field.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String currentUserId;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.currentUserId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(
        chatControllerProvider(widget.conversationId),
      );
      controller.markAsRead(widget.currentUserId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesStream = ref.watch(
      messagesStreamProvider(widget.conversationId),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('conversations')
              .doc(widget.conversationId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text(
                tr('chats.title'),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              );
            }

            final data = snapshot.data?.data() as Map<String, dynamic>?;
            final participants = List<String>.from(
              data?['participantIds'] ?? [],
            );
            final otherUserId = participants.firstWhere(
              (id) => id != widget.currentUserId,
              orElse: () => '',
            );

            if (otherUserId.isEmpty) {
              return Text(
                tr('chats.title'),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              );
            }

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users_test')
                  .doc(otherUserId)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const Text('...');
                }

                final userData =
                    userSnapshot.data?.data() as Map<String, dynamic>?;
                final firstName = userData?['firstName'] ?? '';
                final lastName = userData?['lastName'] ?? '';
                final username = userData?['username'] ?? '';

                final displayName = firstName.isNotEmpty
                    ? '$firstName ${lastName.isNotEmpty ? lastName[0] + '.' : ''}'
                    : username;

                return Text(
                  displayName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesStream.when(
              data: (messages) {
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == widget.currentUserId;

                    return MessageBubble(message: message, isMe: isMe);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xFFD4913D)),
                ),
              ),
              error: (e, s) => Center(child: Text('Error: ${e.toString()}')),
            ),
          ),
          MessageInputField(
            onSend: (text) async {
              final controller = ref.read(
                chatControllerProvider(widget.conversationId),
              );
              await controller.sendMessage(
                senderId: widget.currentUserId,
                text: text,
              );
              _scrollToBottom();
            },
          ),
        ],
      ),
    );
  }
}
