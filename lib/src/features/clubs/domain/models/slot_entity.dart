import 'package:cloud_firestore/cloud_firestore.dart';

part 'slot_entity_mapper.part.dart';

enum SlotType {
  course,
  openPlay,
  event;

  String get displayName => switch (this) {
    SlotType.course => 'Course',
    SlotType.openPlay => 'Open Play',
    SlotType.event => 'Event',
  };
}

class SlotEntity {
  final String id;
  final String clubId;
  final SlotType type;
  final DateTime startTime;
  final DateTime endTime;
  final int maxParticipants;
  final List<String> participants;
  final String? level;
  final String? ageGroup;
  final int? courtNumber;
  final String? roomName;
  final bool isRecurring;
  final String? recurrencePattern;
  final DateTime createdAt;
  final String? description;
  final double? price;

  const SlotEntity({
    required this.id,
    required this.clubId,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.maxParticipants,
    required this.participants,
    this.level,
    this.ageGroup,
    this.courtNumber,
    this.roomName,
    required this.isRecurring,
    this.recurrencePattern,
    required this.createdAt,
    this.description,
    this.price,
  });

  bool get isFull => participants.length >= maxParticipants;
  int get availableSpots => maxParticipants - participants.length;
  double get fillRate => participants.length / maxParticipants;
  bool get isUpcoming => endTime.isAfter(DateTime.now());
  bool get isOngoing {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  bool get isPast => endTime.isBefore(DateTime.now());
  Duration get duration => endTime.difference(startTime);

  SlotEntity copyWith({
    String? id,
    String? clubId,
    SlotType? type,
    DateTime? startTime,
    DateTime? endTime,
    int? maxParticipants,
    List<String>? participants,
    String? level,
    String? ageGroup,
    int? courtNumber,
    String? roomName,
    bool? isRecurring,
    String? recurrencePattern,
    DateTime? createdAt,
    String? description,
    double? price,
  }) => _slotCopyWith(
    this,
    id: id,
    clubId: clubId,
    type: type,
    startTime: startTime,
    endTime: endTime,
    maxParticipants: maxParticipants,
    participants: participants,
    level: level,
    ageGroup: ageGroup,
    courtNumber: courtNumber,
    roomName: roomName,
    isRecurring: isRecurring,
    recurrencePattern: recurrencePattern,
    createdAt: createdAt,
    description: description,
    price: price,
  );

  factory SlotEntity.fromFirestore(DocumentSnapshot doc) =>
      _slotFromFirestore(doc);
  Map<String, dynamic> toFirestore() => _slotToFirestore(this);
}
