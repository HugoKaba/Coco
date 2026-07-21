part of 'firestore_seeder_service.dart';

/// Une ligne d'un fil de discussion seedé.
/// `fromMe` = message envoyé par l'utilisateur courant (le héros), sinon par le
/// partenaire de la conversation.
typedef _ChatLine = ({bool fromMe, String text});

/// Scripts de conversations 1-à-1 (type `match`) variés, orientés sport.
/// Chaque script est attribué à un partenaire différent tiré de `users_test`.
const List<List<_ChatLine>> _conversationScripts = [
  [
    (fromMe: false, text: 'Salut ! Partant pour un tennis ce week-end ?'),
    (fromMe: true, text: 'Carrément 💪 Samedi matin ça te va ?'),
    (fromMe: false, text: 'Parfait, 10h au TC de Vincennes ?'),
    (fromMe: true, text: 'Nickel, je réserve le court 👍'),
    (fromMe: false, text: 'Top, à samedi !'),
  ],
  [
    (fromMe: true, text: 'Hello ! Tu cours toujours le long du canal ?'),
    (fromMe: false, text: 'Oui presque tous les matins 🏃'),
    (fromMe: true, text: 'On se fait une sortie ensemble demain ?'),
    (fromMe: false, text: 'Avec plaisir, 7h devant le métro ?'),
    (fromMe: false, text: "Prévois une veste, il fait frais tôt !"),
  ],
  [
    (fromMe: false, text: 'Salut, il nous manque un joueur dimanche pour le foot'),
    (fromMe: true, text: 'Je suis chaud ! Quel poste ?'),
    (fromMe: false, text: 'Milieu, ça te va ?'),
    (fromMe: true, text: 'Parfait 😎 On joue où ?'),
    (fromMe: false, text: 'Stade Charléty, 14h. Je te note dans la compo 📋'),
  ],
  [
    (fromMe: true, text: 'Yo ! On monte une équipe de padel ?'),
    (fromMe: false, text: 'Grave, je cherchais justement un partenaire'),
    (fromMe: true, text: 'Génial, on teste ce week-end ?'),
    (fromMe: false, text: 'Je réserve un terrain à Bastille 🎾'),
  ],
  [
    (fromMe: false, text: 'Coucou, dispo pour un badminton cette semaine ?'),
    (fromMe: true, text: 'Oui jeudi soir si tu veux'),
    (fromMe: false, text: '19h au gymnase, ça marche pour toi ?'),
    (fromMe: true, text: 'Impec, je ramène les volants 🏸'),
  ],
  [
    (fromMe: false, text: 'Hey ! Bien la séance de hier ?'),
    (fromMe: true, text: 'Ouais crevé mais content 😅'),
    (fromMe: false, text: 'On remet ça vendredi au même créneau ?'),
    (fromMe: false, text: "J'ai gardé une place au cours de 18h 🙌"),
  ],
];

extension _SeederConversations on FirestoreSeederService {
  /// Crée des conversations `match` réalistes entre l'utilisateur courant
  /// (`myUserId`) et plusieurs partenaires distincts issus de `users_test`,
  /// avec un fil de messages et un état de lecture cohérent.
  ///
  /// Prérequis : les utilisateurs doivent déjà exister (« Seed Test Data »),
  /// sinon les partenaires sont introuvables et rien n'est créé.
  Future<void> _seedConversations() async {
    await _deleteCollection('conversations');

    // « Moi » = l'utilisateur réellement connecté (Firebase Auth), pas le héros
    // codé en dur : l'écran Chats filtre les conversations sur l'uid connecté,
    // donc sans ça aucune conversation seedée ne s'afficherait.
    final meId =
        FirebaseAuth.instance.currentUser?.uid ??
        FirestoreSeederService.myUserId;

    final usersSnap = await _firestore
        .collection('users_test')
        .limit(50)
        .get();
    final partnerIds = usersSnap.docs
        .map((d) => d.id)
        .where((id) => id != meId)
        .toList()
      ..shuffle();

    if (partnerIds.isEmpty) return;

    final now = DateTime.now();
    final count = min(_conversationScripts.length, partnerIds.length);

    for (int c = 0; c < count; c++) {
      final partnerId = partnerIds[c];
      final script = _conversationScripts[c];

      // Nombre de messages non lus en fin de fil (bloc de messages consécutifs
      // envoyés par le partenaire à la toute fin) → sert au badge « non lu ».
      int trailingUnread = 0;
      for (int m = script.length - 1; m >= 0; m--) {
        if (script[m].fromMe) break;
        trailingUnread++;
      }

      // Chaque conversation est décalée d'un jour pour obtenir une liste triée
      // du plus récent au plus ancien.
      final base = now.subtract(
        Duration(days: c, minutes: script.length * 3),
      );
      final convRef = _firestore.collection('conversations').doc();

      DateTime lastTime = base;
      String lastText = '';
      for (int m = 0; m < script.length; m++) {
        final line = script[m];
        final ts = base.add(Duration(minutes: m * 3));
        lastTime = ts;
        lastText = line.text;

        final senderId = line.fromMe ? meId : partnerId;
        final isUnreadByMe =
            !line.fromMe && m >= script.length - trailingUnread;
        final readBy = isUnreadByMe ? [partnerId] : [meId, partnerId];

        await convRef.collection('messages').doc().set({
          'conversationId': convRef.id,
          'senderId': senderId,
          'text': line.text,
          'timestamp': Timestamp.fromDate(ts),
          'readBy': readBy,
          'type': 'text',
        });
      }

      await convRef.set({
        'participantIds': [meId, partnerId],
        'type': 'match',
        'eventId': null,
        'slotId': null,
        'title': null,
        'lastMessage': lastText,
        'lastMessageTime': Timestamp.fromDate(lastTime),
        'unreadCount': {meId: trailingUnread, partnerId: 0},
        'createdAt': Timestamp.fromDate(base),
        'updatedAt': Timestamp.fromDate(lastTime),
      });
    }
  }
}
