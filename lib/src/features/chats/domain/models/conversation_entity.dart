import 'package:cloud_firestore/cloud_firestore.dart';

enum ConversationType { match, event, slot }

class ConversationEntity {
  final String id;
  final List<String> participantIds;
  final ConversationType type;
  final String? eventId;
  final String? slotId; // New field
  final String? title; // New field for group chat name
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final Map<String, int> unreadCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ConversationEntity({
    required this.id,
    required this.participantIds,
    required this.type,
    this.eventId,
    this.slotId,
    this.title,
    this.lastMessage,
    this.lastMessageTime,
    required this.unreadCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConversationEntity(
      id: doc.id,
      participantIds: List<String>.from(data['participantIds'] ?? []),
      type: _parseType(data['type']),
      eventId: data['eventId'],
      slotId: data['slotId'],
      title: data['title'], // Allow title to be null for old matches
      lastMessage: data['lastMessage'],
      lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate(),
      unreadCount: Map<String, int>.from(data['unreadCount'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  static ConversationType _parseType(String? type) {
    switch (type) {
      case 'event':
        return ConversationType.event;
      case 'slot':
        return ConversationType.slot;
      default:
        return ConversationType.match;
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'participantIds': participantIds,
      'type': type.name,
      'eventId': eventId,
      'slotId': slotId,
      'title': title,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime != null
          ? Timestamp.fromDate(lastMessageTime!)
          : null,
      'unreadCount': unreadCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ConversationEntity copyWith({
    String? id,
    List<String>? participantIds,
    ConversationType? type,
    String? eventId,
    String? slotId,
    String? title,
    String? lastMessage,
    DateTime? lastMessageTime,
    Map<String, int>? unreadCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConversationEntity(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      type: type ?? this.type,
      eventId: eventId ?? this.eventId,
      slotId: slotId ?? this.slotId,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
