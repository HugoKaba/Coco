import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coco/src/core/city_service.dart';
import 'package:coco/src/features/clubs/application/club_providers.dart';
import 'package:coco/src/features/clubs/domain/models/club_sport_catalog.dart';
import 'package:coco/src/features/clubs/domain/models/club_entity.dart';
import 'package:coco/src/features/clubs/domain/models/opening_hours.dart';
import 'package:coco/src/features/clubs/domain/models/subscription_tier.dart';

Future<void> submitClubCreation({
  required WidgetRef ref,
  required SubscriptionType subscriptionType,
  required String email,
  required String password,
  required String clubName,
  required List<String> activities,
  required String description,
  required String facilities,
  required File? imageFile,
  required String address,
  required String cityName,
  required String phone,
}) async {
  final clubRepository = ref.read(clubRepositoryProvider);
  final user = await _resolveClubOwner(email: email.trim(), password: password);

  final userId = user.uid;
  final imageUrl = await _uploadClubImage(imageFile, userId);

  final city = CityService.instance.findCityByName(cityName);
  final now = DateTime.now();
  final expiresAt = subscriptionType == SubscriptionType.monthly
      ? now.add(const Duration(days: 30))
      : now.add(const Duration(days: 365));
  final normalizedActivities = ClubSportCatalog.ensureKnownKeys(activities);
  final parsedFacilities = facilities
      .split(RegExp(r'[\n,]'))
      .map((facility) => facility.trim())
      .where((facility) => facility.isNotEmpty)
      .toList();
  final clubImageUrl =
      imageUrl ??
      ClubEntity.defaultImageUrlFor(
        normalizedActivities.isEmpty ? null : normalizedActivities.first,
      );

  final club = ClubEntity(
    id: '',
    ownerId: userId,
    name: clubName,
    activities: normalizedActivities,
    description: description,
    facilities: parsedFacilities,
    address: address,
    city: cityName,
    lat: city?.latitude ?? 0,
    lng: city?.longitude ?? 0,
    logoUrl: clubImageUrl,
    photoUrls: [clubImageUrl],
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

  await clubRepository.createClub(club);
}

Future<User> _resolveClubOwner({
  required String email,
  required String password,
}) async {
  final auth = FirebaseAuth.instance;
  final currentUser = auth.currentUser;
  final normalizedEmail = email.trim().toLowerCase();

  if (currentUser != null &&
      currentUser.email?.toLowerCase() == normalizedEmail) {
    return currentUser;
  }

  try {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user == null) throw Exception('User creation failed');
    return user;
  } on FirebaseAuthException catch (e) {
    if (e.code != 'email-already-in-use') rethrow;

    final credential = await auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user == null) throw Exception('User sign in failed');
    return user;
  }
}

Future<String?> _uploadClubImage(File? imageFile, String userId) async {
  if (imageFile == null) return null;

  try {
    final storageRef = FirebaseStorage.instance.ref().child(
      'clubs/$userId/cover.jpg',
    );
    final uploadTask = await storageRef.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return uploadTask.ref.getDownloadURL();
  } on FirebaseException catch (e) {
    throw Exception(
      tr('clubs.create.image_upload_error', namedArgs: {'code': e.code}),
    );
  } catch (_) {
    throw Exception('clubs.create.image_upload_error_generic'.tr());
  }
}
