import 'package:cloud_firestore/cloud_firestore.dart';

enum ConversationType { match, event }

class ConversationEntity {
  final String id;
  final List<String> participantIds;
  final ConversationType type;
  final String? eventId;
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
      type: data['type'] == 'event'
          ? ConversationType.event
          : ConversationType.match,
      eventId: data['eventId'],
      lastMessage: data['lastMessage'],
      lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate(),
      unreadCount: Map<String, int>.from(data['unreadCount'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'participantIds': participantIds,
      'type': type == ConversationType.event ? 'event' : 'match',
      'eventId': eventId,
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
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
