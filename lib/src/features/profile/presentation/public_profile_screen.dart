import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/features/chats/presentation/pages/chat_screen.dart';
import 'package:coco/src/features/filters/domain/models/person_entity.dart';
import 'package:coco/src/features/profile/data/profile_repository.dart';
import 'package:coco/src/features/swap/widgets/person_mapper.dart';
import 'package:coco/src/features/swap/widgets/profile_card.dart';
import 'package:coco/src/shared/widgets/app_button.dart';

class PublicProfileScreen extends ConsumerWidget {
  final String userId;
  final PersonEntity? cachedPerson;

  const PublicProfileScreen({
    super.key,
    required this.userId,
    this.cachedPerson,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personAsync = cachedPerson != null
        ? AsyncValue<PersonEntity?>.data(cachedPerson)
        : ref.watch(publicPersonProvider(userId));

    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: personAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Profil introuvable')),
        data: (person) {
          if (person == null) {
            return const Center(child: Text('Profil introuvable'));
          }
          return ProfileCard(profile: person.toProfile());
        },
      ),
      bottomNavigationBar: personAsync.valueOrNull != null
          ? _BottomMessageBar(targetUserId: personAsync.valueOrNull!.id)
          : null,
    );
  }
}

class _BottomMessageBar extends StatefulWidget {
  final String targetUserId;
  const _BottomMessageBar({required this.targetUserId});

  @override
  State<_BottomMessageBar> createState() => _BottomMessageBarState();
}

class _BottomMessageBarState extends State<_BottomMessageBar> {
  bool _loading = false;

  Future<void> _openOrCreateChat() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    setState(() => _loading = true);
    try {
      final snap = await FirebaseFirestore.instance
          .collection('conversations')
          .where('participantIds', arrayContains: currentUserId)
          .get();

      final existing = snap.docs.where((doc) {
        final participants =
            List<String>.from(doc.data()['participantIds'] ?? []);
        return participants.contains(widget.targetUserId) &&
            doc.data()['type'] == 'match';
      }).firstOrNull;

      String conversationId;
      if (existing != null) {
        conversationId = existing.id;
      } else {
        final newRef = await FirebaseFirestore.instance
            .collection('conversations')
            .add({
          'participantIds': [currentUserId, widget.targetUserId],
          'type': 'match',
          'lastMessage': null,
          'lastMessageTime': null,
          'unreadCount': {},
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        conversationId = newRef.id;
      }

      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            conversationId: conversationId,
            currentUserId: currentUserId,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        MediaQuery.of(context).padding.bottom + AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: AppButton(
        label: 'Envoyer un message',
        icon: Icons.chat_bubble_outline_rounded,
        isLoading: _loading,
        onPressed: _openOrCreateChat,
      ),
    );
  }
}
