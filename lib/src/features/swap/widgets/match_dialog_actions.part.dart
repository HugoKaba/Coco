part of 'match_dialog.dart';

Future<void> _openChat(BuildContext context, PersonEntity person) async {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId == null) {
    Navigator.of(context).pop();
    return;
  }
  try {
    final snap = await FirebaseFirestore.instance
        .collection('conversations')
        .where('participantIds', arrayContains: currentUserId)
        .get();
    final conversation = snap.docs.firstWhere((doc) {
      final data = doc.data();
      final participants = List<String>.from(data['participantIds'] ?? []);
      return participants.contains(person.id) && data['type'] == 'match';
    });
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          conversationId: conversation.id,
          currentUserId: currentUserId,
        ),
      ),
    );
  } catch (_) {
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
  }
}
