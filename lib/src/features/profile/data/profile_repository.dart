import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coco/src/features/profile/domain/user_profile.dart';
import '../../../core/providers.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users_test').doc(userId).get();
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      } else {
        // Create default profile if not found (Dev/Test mode)
        final defaultProfile = UserProfile(
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
        await updateUserProfile(defaultProfile);
        return defaultProfile;
      }
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

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

final userProfileProvider = StreamProvider.autoDispose<UserProfile?>((ref) {
  final authUser = ref.watch(authStateChangesProvider).value;
  if (authUser == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users_test')
      .doc(authUser.uid)
      .snapshots()
      .asyncMap((doc) async {
        if (!doc.exists) {
          final defaultProfile = UserProfile(
            id: authUser.uid,
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
          try {
            await FirebaseFirestore.instance
                .collection('users_test')
                .doc(authUser.uid)
                .set(defaultProfile.toFirestore());
            return defaultProfile;
          } catch (e) {
            return null;
          }
        }
        return UserProfile.fromFirestore(doc);
      });
});
