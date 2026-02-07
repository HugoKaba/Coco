import 'package:cloud_firestore/cloud_firestore.dart';

class SlotChat {
  final String id;
  final String slotId;
  final String clubId;
  final String chatChannelId;
  final List<String> participants;
  final DateTime createdAt;
  final DateTime? lastMessageAt;

  const SlotChat({
    required this.id,
    required this.slotId,
    required this.clubId,
    required this.chatChannelId,
    required this.participants,
    required this.createdAt,
    this.lastMessageAt,
  });

  int get participantCount => participants.length;

  bool get hasMessages => lastMessageAt != null;

  SlotChat copyWith({
    String? id,
    String? slotId,
    String? clubId,
    String? chatChannelId,
    List<String>? participants,
    DateTime? createdAt,
    DateTime? lastMessageAt,
  }) {
    return SlotChat(
      id: id ?? this.id,
      slotId: slotId ?? this.slotId,
      clubId: clubId ?? this.clubId,
      chatChannelId: chatChannelId ?? this.chatChannelId,
      participants: participants ?? this.participants,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }

  factory SlotChat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    DateTime? parseDateNullable(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      return null;
    }

    return SlotChat(
      id: doc.id,
      slotId: data['slotId']?.toString() ?? '',
      clubId: data['clubId']?.toString() ?? '',
      chatChannelId: data['chatChannelId']?.toString() ?? '',
      participants:
          (data['participants'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: parseDate(data['createdAt']),
      lastMessageAt: parseDateNullable(data['lastMessageAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'slotId': slotId,
      'clubId': clubId,
      'chatChannelId': chatChannelId,
      'participants': participants,
      'createdAt': Timestamp.fromDate(createdAt),
      if (lastMessageAt != null)
        'lastMessageAt': Timestamp.fromDate(lastMessageAt!),
    };
  }
}
