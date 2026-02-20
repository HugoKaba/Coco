import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/club_repository.dart';
import '../../domain/models/club_membership.dart';

class FirestoreMembershipRepository implements MembershipRepository {
  final FirebaseFirestore _firestore;
  final _collection = 'club_memberships';

  FirestoreMembershipRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<ClubMembership?> getMembership(String userId, String clubId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('clubId', isEqualTo: clubId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return ClubMembership.fromFirestore(snapshot.docs.first);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ClubMembership>> getUserMemberships(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((doc) => ClubMembership.fromFirestore(doc))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ClubMembership>> getClubMembers(String clubId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('clubId', isEqualTo: clubId)
          .where('isActive', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((doc) => ClubMembership.fromFirestore(doc))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<String> createMembership(ClubMembership membership) async {
    final docRef = await _firestore
        .collection(_collection)
        .add(membership.toFirestore());
    return docRef.id;
  }

  @override
  Future<void> updateMembership(ClubMembership membership) async {
    await _firestore
        .collection(_collection)
        .doc(membership.id)
        .update(membership.toFirestore());
  }

  @override
  Future<void> deleteMembership(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  @override
  Future<bool> isMember(String userId, String clubId) async {
    final membership = await getMembership(userId, clubId);
    return membership?.isActive ?? false;
  }

  @override
  Future<void> addBookedSlot(String membershipId, String slotId) async {
    await _firestore.collection(_collection).doc(membershipId).update({
      'bookedSlots': FieldValue.arrayUnion([slotId]),
    });
  }

  @override
  Future<void> removeBookedSlot(String membershipId, String slotId) async {
    await _firestore.collection(_collection).doc(membershipId).update({
      'bookedSlots': FieldValue.arrayRemove([slotId]),
    });
  }
}
