import 'package:cloud_firestore/cloud_firestore.dart';

class ClubMembership {
  final String id;
  final String userId;
  final String clubId;
  final DateTime joinedAt;
  final bool isActive;
  final List<String> bookedSlots;
  final String? membershipType;
  final DateTime? expiresAt;

  const ClubMembership({
    required this.id,
    required this.userId,
    required this.clubId,
    required this.joinedAt,
    required this.isActive,
    required this.bookedSlots,
    this.membershipType,
    this.expiresAt,
  });

  int get totalBookings => bookedSlots.length;

  bool get hasActiveBookings => bookedSlots.isNotEmpty;

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  ClubMembership copyWith({
    String? id,
    String? userId,
    String? clubId,
    DateTime? joinedAt,
    bool? isActive,
    List<String>? bookedSlots,
    String? membershipType,
    DateTime? expiresAt,
  }) {
    return ClubMembership(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clubId: clubId ?? this.clubId,
      joinedAt: joinedAt ?? this.joinedAt,
      isActive: isActive ?? this.isActive,
      bookedSlots: bookedSlots ?? this.bookedSlots,
      membershipType: membershipType ?? this.membershipType,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  factory ClubMembership.fromFirestore(DocumentSnapshot doc) {
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

    return ClubMembership(
      id: doc.id,
      userId: data['userId']?.toString() ?? '',
      clubId: data['clubId']?.toString() ?? '',
      joinedAt: parseDate(data['joinedAt']),
      isActive: data['isActive'] as bool? ?? true,
      bookedSlots:
          (data['bookedSlots'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      membershipType: data['membershipType']?.toString(),
      expiresAt: parseDateNullable(data['expiresAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'clubId': clubId,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'isActive': isActive,
      'bookedSlots': bookedSlots,
      if (membershipType != null) 'membershipType': membershipType,
      if (expiresAt != null) 'expiresAt': Timestamp.fromDate(expiresAt!),
    };
  }
}
