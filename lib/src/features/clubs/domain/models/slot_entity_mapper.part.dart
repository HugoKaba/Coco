part of 'slot_entity.dart';

SlotEntity _slotCopyWith(
  SlotEntity s, {
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
    id: id ?? s.id,
    clubId: clubId ?? s.clubId,
    type: type ?? s.type,
    startTime: startTime ?? s.startTime,
    endTime: endTime ?? s.endTime,
    maxParticipants: maxParticipants ?? s.maxParticipants,
    participants: participants ?? s.participants,
    level: level ?? s.level,
    ageGroup: ageGroup ?? s.ageGroup,
    courtNumber: courtNumber ?? s.courtNumber,
    roomName: roomName ?? s.roomName,
    isRecurring: isRecurring ?? s.isRecurring,
    recurrencePattern: recurrencePattern ?? s.recurrencePattern,
    createdAt: createdAt ?? s.createdAt,
    description: description ?? s.description,
    price: price ?? s.price,
  );
}

SlotEntity _slotFromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  DateTime parseDate(dynamic v) => v is Timestamp
      ? v.toDate()
      : (v is String ? DateTime.tryParse(v) ?? DateTime.now() : DateTime.now());
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

Map<String, dynamic> _slotToFirestore(SlotEntity s) => {
  'clubId': s.clubId,
  'type': s.type.name,
  'startTime': Timestamp.fromDate(s.startTime),
  'endTime': Timestamp.fromDate(s.endTime),
  'maxParticipants': s.maxParticipants,
  'participants': s.participants,
  if (s.level != null) 'level': s.level,
  if (s.ageGroup != null) 'ageGroup': s.ageGroup,
  if (s.courtNumber != null) 'courtNumber': s.courtNumber,
  if (s.roomName != null) 'roomName': s.roomName,
  'isRecurring': s.isRecurring,
  if (s.recurrencePattern != null) 'recurrencePattern': s.recurrencePattern,
  'createdAt': Timestamp.fromDate(s.createdAt),
  if (s.description != null) 'description': s.description,
  if (s.price != null) 'price': s.price,
};
