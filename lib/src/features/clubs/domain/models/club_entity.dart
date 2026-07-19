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
  String get fallbackImageUrl => defaultImageUrlFor(primaryActivity);
  String get coverImageUrl => photoUrls.isNotEmpty
      ? photoUrls.first
      : logoUrl != null && logoUrl!.trim().isNotEmpty
      ? logoUrl!
      : fallbackImageUrl;
  String get avatarImageUrl =>
      logoUrl != null && logoUrl!.trim().isNotEmpty ? logoUrl! : coverImageUrl;

  static String defaultImageUrlFor(String? sportKey) {
    return switch (sportKey) {
      'tennis' =>
        'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?auto=format&fit=crop&w=1200&q=80',
      'fitness' =>
        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=1200&q=80',
      'football' =>
        'https://images.unsplash.com/photo-1459865264687-595d652de67e?auto=format&fit=crop&w=1200&q=80',
      'running' =>
        'https://images.unsplash.com/photo-1502904550040-7534597429ae?auto=format&fit=crop&w=1200&q=80',
      _ =>
        'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&w=1200&q=80',
    };
  }

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
