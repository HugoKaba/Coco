import 'package:cloud_firestore/cloud_firestore.dart';

import 'opening_hours.dart';
import 'subscription_tier.dart';

part 'club_entity_mapper.part.dart';

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

  bool get isSubscriptionActive =>
      DateTime.now().isBefore(subscriptionExpiresAt);
  int get subscriptionDaysRemaining => isSubscriptionActive
      ? subscriptionExpiresAt.difference(DateTime.now()).inDays
      : 0;

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
  }) => _clubCopyWith(
    this,
    id: id,
    ownerId: ownerId,
    name: name,
    sportType: sportType,
    description: description,
    address: address,
    city: city,
    lat: lat,
    lng: lng,
    logoUrl: logoUrl,
    photoUrls: photoUrls,
    weeklyHours: weeklyHours,
    maxCapacity: maxCapacity,
    createdAt: createdAt,
    subscriptionType: subscriptionType,
    subscriptionExpiresAt: subscriptionExpiresAt,
    isActive: isActive,
    phone: phone,
    email: email,
    website: website,
  );

  factory ClubEntity.fromFirestore(DocumentSnapshot doc) =>
      _clubFromFirestore(doc);
  Map<String, dynamic> toFirestore() => _clubToFirestore(this);
}
