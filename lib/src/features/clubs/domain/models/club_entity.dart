import 'package:cloud_firestore/cloud_firestore.dart';
import 'opening_hours.dart';
import 'subscription_tier.dart';

class ClubEntity {
  final String id;
  final String ownerId;
  final String name;
  final String sportType;
  final String description;
  final String address;
  final String city;
  final double lat;
  final double lng;
  final String? logoUrl;
  final List<String> photoUrls;
  final Map<String, OpeningHours> weeklyHours;
  final int maxCapacity;
  final DateTime createdAt;
  final SubscriptionType subscriptionType;
  final DateTime subscriptionExpiresAt;
  final bool isActive;
  final String? phone;
  final String? email;
  final String? website;

  const ClubEntity({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.sportType,
    required this.description,
    required this.address,
    required this.city,
    required this.lat,
    required this.lng,
    this.logoUrl,
    required this.photoUrls,
    required this.weeklyHours,
    required this.maxCapacity,
    required this.createdAt,
    required this.subscriptionType,
    required this.subscriptionExpiresAt,
    required this.isActive,
    this.phone,
    this.email,
    this.website,
  });

  bool get isSubscriptionActive {
    return DateTime.now().isBefore(subscriptionExpiresAt);
  }

  int get subscriptionDaysRemaining {
    if (!isSubscriptionActive) return 0;
    return subscriptionExpiresAt.difference(DateTime.now()).inDays;
  }

  ClubEntity copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? sportType,
    String? description,
    String? address,
    String? city,
    double? lat,
    double? lng,
    String? logoUrl,
    List<String>? photoUrls,
    Map<String, OpeningHours>? weeklyHours,
    int? maxCapacity,
    DateTime? createdAt,
    SubscriptionType? subscriptionType,
    DateTime? subscriptionExpiresAt,
    bool? isActive,
    String? phone,
    String? email,
    String? website,
  }) {
    return ClubEntity(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      sportType: sportType ?? this.sportType,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      logoUrl: logoUrl ?? this.logoUrl,
      photoUrls: photoUrls ?? this.photoUrls,
      weeklyHours: weeklyHours ?? this.weeklyHours,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      createdAt: createdAt ?? this.createdAt,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      subscriptionExpiresAt:
          subscriptionExpiresAt ?? this.subscriptionExpiresAt,
      isActive: isActive ?? this.isActive,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
    );
  }

  factory ClubEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    Map<String, OpeningHours> parseWeeklyHours(dynamic val) {
      if (val is Map) {
        return val.map((key, value) {
          return MapEntry(
            key.toString(),
            OpeningHours.fromMap(value as Map<String, dynamic>),
          );
        });
      }
      return {};
    }

    return ClubEntity(
      id: doc.id,
      ownerId: data['ownerId']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      sportType: data['sportType']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      city: data['city']?.toString() ?? '',
      lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
      logoUrl: data['logoUrl']?.toString(),
      photoUrls:
          (data['photoUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      weeklyHours: parseWeeklyHours(data['weeklyHours']),
      maxCapacity: (data['maxCapacity'] as num?)?.toInt() ?? 0,
      createdAt: parseDate(data['createdAt']),
      subscriptionType: SubscriptionType.values.firstWhere(
        (e) => e.name == data['subscriptionType'],
        orElse: () => SubscriptionType.monthly,
      ),
      subscriptionExpiresAt: parseDate(data['subscriptionExpiresAt']),
      isActive: data['isActive'] as bool? ?? true,
      phone: data['phone']?.toString(),
      email: data['email']?.toString(),
      website: data['website']?.toString(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'name': name,
      'sportType': sportType,
      'description': description,
      'address': address,
      'city': city,
      'lat': lat,
      'lng': lng,
      'geopoint': GeoPoint(lat, lng),
      if (logoUrl != null) 'logoUrl': logoUrl,
      'photoUrls': photoUrls,
      'weeklyHours': weeklyHours.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
      'maxCapacity': maxCapacity,
      'createdAt': Timestamp.fromDate(createdAt),
      'subscriptionType': subscriptionType.name,
      'subscriptionExpiresAt': Timestamp.fromDate(subscriptionExpiresAt),
      'isActive': isActive,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (website != null) 'website': website,
    };
  }
}
