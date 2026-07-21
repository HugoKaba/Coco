import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coco/src/features/profile/domain/user_profile.dart';
import 'package:coco/src/features/filters/domain/models/person_entity.dart';
import 'package:coco/src/features/filters/data/mappers/user_mapper.dart';
import '../../../core/providers.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users_test').doc(userId).get();
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      // Profil absent : on l'amorce, en reprenant l'identité du compte connecté
      // (Google/Firebase) quand c'est bien le sien.
      final authUser = FirebaseAuth.instance.currentUser;
      final defaultProfile = (authUser != null && authUser.uid == userId)
          ? defaultProfileForUser(authUser)
          : placeholderProfile(userId);
      await _firestore
          .collection('users_test')
          .doc(userId)
          .set(defaultProfile.toFirestore());
      return defaultProfile;
    } catch (e) {
      // ignore: avoid_print
      print('Error getting user profile: $e');
      return null;
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    await _firestore
        .collection('users_test')
        .doc(profile.id)
        .update(profile.toFirestore());
  }
}

/// Profil par défaut construit à partir de l'identité du compte Firebase
/// (connexion Google notamment) : nom/prénom depuis `displayName`, avatar depuis
/// `photoURL`. Le reste reste des valeurs neutres, éditables ensuite.
UserProfile defaultProfileForUser(User user) {
  final displayName = (user.displayName ?? '').trim();
  String firstName = 'User';
  String lastName = 'Test';
  if (displayName.isNotEmpty) {
    final parts = displayName.split(RegExp(r'\s+'));
    firstName = parts.first;
    lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
  } else if ((user.email ?? '').isNotEmpty) {
    firstName = user.email!.split('@').first;
    lastName = '';
  }
  return UserProfile(
    id: user.uid,
    firstName: firstName,
    lastName: lastName,
    age: 25,
    gender: 'M',
    city: 'Paris',
    bio: 'Nouveau membre',
    profilePhoto: user.photoURL ?? '',
    trainingFrequency: 2,
    sportsGoal: 'Loisir',
    days: [],
    userSports: [],
  );
}

/// Profil par défaut « anonyme » (aucune identité disponible).
UserProfile placeholderProfile(String userId) => UserProfile(
  id: userId,
  firstName: 'User',
  lastName: 'Test',
  age: 25,
  gender: 'M',
  city: 'Paris',
  bio: 'Nouveau membre',
  profilePhoto: '',
  trainingFrequency: 2,
  sportsGoal: 'Loisir',
  days: [],
  userSports: [],
);

/// Vrai si le profil a manifestement été auto-créé en placeholder et jamais
/// édité (mêmes valeurs exactes). Sert à le compléter rétroactivement avec
/// l'identité Google si elle est désormais disponible.
bool _looksLikeUntouchedPlaceholder(UserProfile p) =>
    p.firstName == 'User' &&
    p.lastName == 'Test' &&
    p.bio == 'Nouveau membre' &&
    p.profilePhoto.isEmpty;

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

final publicPersonProvider =
    FutureProvider.autoDispose.family<PersonEntity?, String>((ref, userId) async {
  final doc = await FirebaseFirestore.instance
      .collection('users_test')
      .doc(userId)
      .get();
  if (!doc.exists) return null;
  return UserMapper.fromFirestore(doc);
});

final userProfileProvider = StreamProvider.autoDispose<UserProfile?>((ref) {
  final authUser = ref.watch(authStateChangesProvider).value;
  if (authUser == null) return Stream.value(null);

  final docRef = FirebaseFirestore.instance
      .collection('users_test')
      .doc(authUser.uid);

  return docRef.snapshots().asyncMap((doc) async {
    // Premier accès : on crée le profil depuis l'identité Google.
    if (!doc.exists) {
      final profile = defaultProfileForUser(authUser);
      try {
        await docRef.set(profile.toFirestore());
        return profile;
      } catch (e) {
        return null;
      }
    }

    final existing = UserProfile.fromFirestore(doc);
    // Rattrapage : profil auto-créé avant qu'on récupère l'identité Google →
    // s'il n'a jamais été édité et qu'un displayName est désormais dispo, on le
    // complète (une seule fois, l'update ré-émet un snapshot non-placeholder).
    if (_looksLikeUntouchedPlaceholder(existing) &&
        ((authUser.displayName ?? '').trim().isNotEmpty ||
            (authUser.photoURL ?? '').isNotEmpty)) {
      final upgraded = defaultProfileForUser(authUser);
      try {
        await docRef.update(upgraded.toFirestore());
        return upgraded;
      } catch (e) {
        return existing;
      }
    }
    return existing;
  });
});
