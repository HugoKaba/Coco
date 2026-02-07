import 'package:cloud_firestore/cloud_firestore.dart';

enum SlotType {
  course,
  openPlay,
  event;

  String get displayName {
    switch (this) {
      case SlotType.course:
        return 'Course';
      case SlotType.openPlay:
        return 'Open Play';
      case SlotType.event:
        return 'Event';
    }
  }
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

  bool get isUpcoming => startTime.isAfter(DateTime.now());

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
  }) {
    return SlotEntity(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      participants: participants ?? this.participants,
      level: level ?? this.level,
      ageGroup: ageGroup ?? this.ageGroup,
      courtNumber: courtNumber ?? this.courtNumber,
      roomName: roomName ?? this.roomName,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }

  factory SlotEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    return SlotEntity(
      id: doc.id,
      clubId: data['clubId']?.toString() ?? '',
      type: SlotType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => SlotType.openPlay,
      ),
      startTime: parseDate(data['startTime']),
      endTime: parseDate(data['endTime']),
      maxParticipants: (data['maxParticipants'] as num?)?.toInt() ?? 0,
      participants:
          (data['participants'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      level: data['level']?.toString(),
      ageGroup: data['ageGroup']?.toString(),
      courtNumber: (data['courtNumber'] as num?)?.toInt(),
      roomName: data['roomName']?.toString(),
      isRecurring: data['isRecurring'] as bool? ?? false,
      recurrencePattern: data['recurrencePattern']?.toString(),
      createdAt: parseDate(data['createdAt']),
      description: data['description']?.toString(),
      price: (data['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'clubId': clubId,
      'type': type.name,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'maxParticipants': maxParticipants,
      'participants': participants,
      if (level != null) 'level': level,
      if (ageGroup != null) 'ageGroup': ageGroup,
      if (courtNumber != null) 'courtNumber': courtNumber,
      if (roomName != null) 'roomName': roomName,
      'isRecurring': isRecurring,
      if (recurrencePattern != null) 'recurrencePattern': recurrencePattern,
      'createdAt': Timestamp.fromDate(createdAt),
      if (description != null) 'description': description,
      if (price != null) 'price': price,
    };
  }
}
