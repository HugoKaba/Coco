import '../models/club_entity.dart';
import '../models/slot_entity.dart';
import '../models/club_membership.dart';

abstract class ClubRepository {
  Future<ClubEntity?> getClubById(String id);

  Future<List<ClubEntity>> getClubsByOwnerId(String ownerId);

  Future<List<ClubEntity>> searchClubsByLocation({
    required double lat,
    required double lng,
    required double radiusKm,
    String? sportType,
  });

  Future<String> createClub(ClubEntity club);

  Future<void> updateClub(ClubEntity club);

  Future<void> deleteClub(String id);

  Future<List<ClubEntity>> getActiveClubs();

  Future<bool> isSubscriptionActive(String clubId);

  Future<void> renewSubscription(String clubId, DateTime newExpiryDate);

  Stream<ClubEntity?> watchClub(String id);
}

abstract class SlotRepository {
  Future<SlotEntity?> getSlotById(String id);

  Future<List<SlotEntity>> getSlotsByClubId(String clubId);

  Future<List<SlotEntity>> getUpcomingSlots(String clubId);

  Future<List<SlotEntity>> getSlotsByDateRange({
    required String clubId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Stream<List<SlotEntity>> watchUpcomingSlots(String clubId);

  Future<String> createSlot(SlotEntity slot);

  Future<void> updateSlot(SlotEntity slot);

  Future<void> deleteSlot(String id);

  Future<bool> bookSlot(String slotId, String userId);

  Future<bool> cancelBooking(String slotId, String userId);

  Future<List<String>> getParticipants(String slotId);

  Stream<SlotEntity?> watchSlot(String id);
}

abstract class MembershipRepository {
  Future<ClubMembership?> getMembership(String userId, String clubId);

  Future<List<ClubMembership>> getUserMemberships(String userId);

  Future<List<ClubMembership>> getClubMembers(String clubId);

  Future<String> createMembership(ClubMembership membership);

  Future<void> updateMembership(ClubMembership membership);

  Future<void> deleteMembership(String id);

  Future<bool> isMember(String userId, String clubId);

  Future<void> addBookedSlot(String membershipId, String slotId);

  Future<void> removeBookedSlot(String membershipId, String slotId);
}
