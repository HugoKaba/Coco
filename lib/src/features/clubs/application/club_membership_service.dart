import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/club_membership.dart';
import '../domain/repositories/club_repository.dart';
import '../../../core/providers.dart';

class ClubMembershipService {
  final MembershipRepository _membershipRepository;
  final Ref _ref;

  ClubMembershipService({
    required MembershipRepository membershipRepository,
    required Ref ref,
  }) : _membershipRepository = membershipRepository,
       _ref = ref;

  Future<void> joinClub(String clubId) async {
    final user = _ref.read(authServiceProvider).currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Check if already a member
    final existingMembership = await _membershipRepository.getMembership(
      user.uid,
      clubId,
    );
    if (existingMembership != null && existingMembership.isActive) {
      return; // Already a member
    }

    if (existingMembership != null && !existingMembership.isActive) {
      // Re-activate membership
      final updatedMembership = existingMembership.copyWith(isActive: true);
      await _membershipRepository.updateMembership(updatedMembership);
    } else {
      // Create new membership
      final newMembership = ClubMembership(
        id: '', // Will be assigned by Firestore
        userId: user.uid,
        clubId: clubId,
        joinedAt: DateTime.now(),
        isActive: true,
        bookedSlots: [],
      );
      await _membershipRepository.createMembership(newMembership);
    }
  }

  Future<void> leaveClub(String clubId) async {
    final user = _ref.read(authServiceProvider).currentUser;
    if (user == null) throw Exception('User not authenticated');

    final membership = await _membershipRepository.getMembership(
      user.uid,
      clubId,
    );
    if (membership != null) {
      // We don't delete, we just deactivate to keep history?
      // Or delete? For now let's just deactivate or delete.
      // The current repo has deleteMembership(id).
      await _membershipRepository.deleteMembership(membership.id);
    }
  }

  Future<bool> isMember(String clubId) async {
    final user = _ref.read(authServiceProvider).currentUser;
    if (user == null) return false;
    return _membershipRepository.isMember(user.uid, clubId);
  }
}
