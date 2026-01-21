import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../chats/presentation/pages/chat_screen.dart';

class MatchDialogActions {
  static Future<void> navigateToChat(
    BuildContext context,
    String personId,
  ) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      Navigator.of(context, rootNavigator: true).pop();
      return;
    }

    try {
      final conversationsSnapshot = await FirebaseFirestore.instance
          .collection('conversations')
          .where('participantIds', arrayContains: currentUserId)
          .get();

      final conversation = conversationsSnapshot.docs.firstWhere((doc) {
        final data = doc.data();
        final participants = List<String>.from(data['participantIds'] ?? []);
        return participants.contains(personId) && data['type'] == 'match';
      });

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();

        await Future.delayed(const Duration(milliseconds: 200));

        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                conversationId: conversation.id,
                currentUserId: currentUserId,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }
}
