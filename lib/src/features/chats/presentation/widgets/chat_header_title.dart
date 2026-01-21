import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatHeaderTitle extends StatelessWidget {
  final String conversationId;
  final String currentUserId;

  const ChatHeaderTitle({
    super.key,
    required this.conversationId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
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
        final participants = List<String>.from(data?['participantIds'] ?? []);
        final otherUserId = participants.firstWhere(
          (id) => id != currentUserId,
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

            final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
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
    );
  }
}
