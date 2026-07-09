import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            Padding(
              padding: const EdgeInsets.only(
                left: 44,
                bottom: 2,
              ), // Align with text
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users_test')
                    .doc(message.senderId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final data = snapshot.data!.data() as Map<String, dynamic>?;
                    final name =
                        data?['firstName'] ?? data?['username'] ?? 'User';
                    return Text(
                      name,
                      style: TextStyle(
                        fontSize: 10,
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end, // Align avatar bottom
            children: [
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFD4913D).withValues(alpha: 0.2),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 16,
                      color: Color(0xFFD4913D),
                    ),
                  ),
                ),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? const Color(0xFFD4913D)
                        : cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: isMe
                          ? const Radius.circular(20)
                          : const Radius.circular(4),
                      bottomRight: isMe
                          ? const Radius.circular(4)
                          : const Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: TextStyle(
                          fontSize: 15,
                          color: isMe ? Colors.white : cs.onSurface,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('HH:mm').format(message.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          color: isMe
                              ? Colors.white.withValues(alpha: 0.8)
                              : cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
