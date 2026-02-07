import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/firestore_club_repository.dart';
import '../data/repositories/firestore_slot_repository.dart';
import '../data/repositories/firestore_membership_repository.dart';
import '../domain/repositories/club_repository.dart';
import '../application/club_booking_service.dart';
import '../application/club_search_service.dart';
import '../application/club_membership_service.dart';

final clubRepositoryProvider = Provider<ClubRepository>((ref) {
  return FirestoreClubRepository();
});

final slotRepositoryProvider = Provider<SlotRepository>((ref) {
  return FirestoreSlotRepository();
});

final membershipRepositoryProvider = Provider<MembershipRepository>((ref) {
  return FirestoreMembershipRepository();
});

final clubBookingServiceProvider = Provider<ClubBookingService>((ref) {
  return ClubBookingService(
    slotRepository: ref.watch(slotRepositoryProvider),
    membershipRepository: ref.watch(membershipRepositoryProvider),
  );
});

final clubMembershipServiceProvider = Provider<ClubMembershipService>((ref) {
  return ClubMembershipService(
    membershipRepository: ref.watch(membershipRepositoryProvider),
    ref: ref,
  );
});

final clubSearchServiceProvider = Provider<ClubSearchService>((ref) {
  return ClubSearchService(clubRepository: ref.watch(clubRepositoryProvider));
});

final userClubsProvider = FutureProvider.family<List<dynamic>, String>((
  ref,
  userId,
) async {
  final membershipRepo = ref.watch(membershipRepositoryProvider);
  return await membershipRepo.getUserMemberships(userId);
});

final clubDetailsProvider = StreamProvider.family<dynamic, String>((
  ref,
  clubId,
) {
  final clubRepo = ref.watch(clubRepositoryProvider);
  return clubRepo.watchClub(clubId);
});

final upcomingSlotsProvider = StreamProvider.family<List<dynamic>, String>((
  ref,
  clubId,
) {
  final slotRepo = ref.watch(slotRepositoryProvider);
  return slotRepo.watchUpcomingSlots(clubId);
});

final isMemberProvider = FutureProvider.family<bool, String>((
  ref,
  clubId,
) async {
  final service = ref.watch(clubMembershipServiceProvider);
  return await service.isMember(clubId);
});
