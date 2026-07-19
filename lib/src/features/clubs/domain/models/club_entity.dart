import 'package:cloud_firestore/cloud_firestore.dart';

import 'club_sport_catalog.dart';
import 'opening_hours.dart';
import 'subscription_tier.dart';

part 'club_entity_mapper.part.dart';

class ClubEntity {
  final String id;
  final String ownerId;
  final String name;
  final List<String> activities;
  final String description;
  final List<String> facilities;
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
    required this.activities,
    required this.description,
    this.facilities = const [],
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
  List<String> get normalizedActivities =>
      ClubSportCatalog.normalizeKeys(activities);
  String get primaryActivity =>
      normalizedActivities.isNotEmpty ? normalizedActivities.first : '';

  ClubEntity copyWith({
    String? id,
    String? ownerId,
    String? name,
    List<String>? activities,
    String? description,
    List<String>? facilities,
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
    activities: activities,
    description: description,
    facilities: facilities,
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
