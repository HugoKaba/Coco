import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../filters/domain/models/person_entity.dart';
import '../../chats/presentation/pages/chat_screen.dart';

class MatchDialog extends StatelessWidget {
  final PersonEntity person;

  const MatchDialog({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: Color(0xFFD4913D),
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                tr('match.title'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFD4913D),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD4913D),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4913D).withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        person.profilePhotoUrl ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.person, size: 50),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                tr('match.description', args: [person.firstName]),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    final currentUserId =
                        FirebaseAuth.instance.currentUser?.uid;
                    if (currentUserId == null) {
                      Navigator.of(context).pop();
                      return;
                    }

                    try {
                      final conversationsSnapshot = await FirebaseFirestore
                          .instance
                          .collection('conversations')
                          .where('participantIds', arrayContains: currentUserId)
                          .get();

                      final conversation = conversationsSnapshot.docs
                          .firstWhere((doc) {
                            final data = doc.data();
                            final participants = List<String>.from(
                              data['participantIds'] ?? [],
                            );
                            return participants.contains(person.id) &&
                                data['type'] == 'match';
                          });

                      if (context.mounted) {
                        Navigator.of(context, rootNavigator: true).pop();
                        await Future.delayed(const Duration(milliseconds: 100));

                        if (context.mounted) {
                          await Navigator.push(
                            context,
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
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4913D),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    tr('match.send_message'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                  ),
                  child: Text(
                    tr('match.keep_swiping'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
