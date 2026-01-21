import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, system }

class MessageEntity {
  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final List<String> readBy;
  final MessageType type;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.readBy,
    this.type = MessageType.text,
  });

  factory MessageEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageEntity(
      id: doc.id,
      conversationId: data['conversationId'] as String,
      senderId: data['senderId'] as String,
      text: data['text'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      readBy: List<String>.from(data['readBy'] ?? []),
      type: data['type'] == 'system' ? MessageType.system : MessageType.text,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'conversationId': conversationId,
      'senderId': senderId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'readBy': readBy,
      'type': type == MessageType.system ? 'system' : 'text',
    };
  }

  MessageEntity copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? text,
    DateTime? timestamp,
    List<String>? readBy,
    MessageType? type,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      readBy: readBy ?? this.readBy,
      type: type ?? this.type,
    );
  }

  bool isReadBy(String userId) => readBy.contains(userId);
}
