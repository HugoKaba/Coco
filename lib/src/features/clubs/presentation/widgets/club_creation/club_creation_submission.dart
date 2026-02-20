import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coco/src/core/city_service.dart';
import 'package:coco/src/features/clubs/application/club_providers.dart';
import 'package:coco/src/features/clubs/domain/models/club_entity.dart';
import 'package:coco/src/features/clubs/domain/models/opening_hours.dart';
import 'package:coco/src/features/clubs/domain/models/subscription_tier.dart';

Future<void> submitClubCreation({
  required WidgetRef ref,
  required SubscriptionType subscriptionType,
  required String email,
  required String password,
  required String clubName,
  required String sportType,
  required String description,
  required String address,
  required String cityName,
  required String phone,
}) async {
  final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email.trim(),
    password: password,
  );

  final userId = user.user?.uid;
  if (userId == null) throw Exception('User creation failed');

  final city = CityService.instance.findCityByName(cityName);
  final now = DateTime.now();
  final expiresAt = subscriptionType == SubscriptionType.monthly
      ? now.add(const Duration(days: 30))
      : now.add(const Duration(days: 365));

  final club = ClubEntity(
    id: '',
    ownerId: userId,
    name: clubName,
    sportType: sportType,
    description: description,
    address: address,
    city: cityName,
    lat: city?.latitude ?? 0,
    lng: city?.longitude ?? 0,
    photoUrls: const [],
    weeklyHours: {
      'Monday': OpeningHours.standard(),
      'Tuesday': OpeningHours.standard(),
      'Wednesday': OpeningHours.standard(),
      'Thursday': OpeningHours.standard(),
      'Friday': OpeningHours.standard(),
      'Saturday': OpeningHours.standard(),
      'Sunday': OpeningHours.closed(),
    },
    maxCapacity: 50,
    createdAt: now,
    subscriptionType: subscriptionType,
    subscriptionExpiresAt: expiresAt,
    isActive: true,
    phone: phone.isEmpty ? null : phone,
  );

  await ref.read(clubRepositoryProvider).createClub(club);
}
