import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import '../domain/repositories/club_repository.dart';
import '../domain/models/slot_entity.dart';
import '../domain/models/club_membership.dart';

class ClubBookingService {
  final SlotRepository _slotRepository;
  final MembershipRepository _membershipRepository;

  ClubBookingService({
    required SlotRepository slotRepository,
    required MembershipRepository membershipRepository,
  }) : _slotRepository = slotRepository,
       _membershipRepository = membershipRepository;

  Future<BookingResult> bookSlot({
    required String slotId,
    required String userId,
    required String clubId,
  }) async {
    try {
      final slot = await _slotRepository.getSlotById(slotId);
      if (slot == null) {
        return BookingResult.failure('clubs.slot.error_not_found'.tr());
      }

      if (slot.isFull) {
        return BookingResult.failure('clubs.slot.error_full'.tr());
      }

      if (slot.isPast) {
        return BookingResult.failure('clubs.slot.error_past'.tr());
      }

      if (slot.participants.contains(userId)) {
        return BookingResult.failure('clubs.slot.error_already_booked'.tr());
      }

      final success = await _slotRepository.bookSlot(slotId, userId);
      if (!success) {
        return BookingResult.failure('clubs.slot.error_booking_failed'.tr());
      }

      final membership = await _membershipRepository.getMembership(
        userId,
        clubId,
      );
      if (membership != null) {
        await _membershipRepository.addBookedSlot(membership.id, slotId);
      } else {
        final newMembership = ClubMembership(
          id: '',
          userId: userId,
          clubId: clubId,
          joinedAt: DateTime.now(),
          isActive: true,
          bookedSlots: [slotId],
        );
        await _membershipRepository.createMembership(newMembership);
      }

      // Auto-join chat
      try {
        final chatQuery = await FirebaseFirestore.instance
            .collection('conversations')
            .where('slotId', isEqualTo: slotId)
            .limit(1)
            .get();

        if (chatQuery.docs.isNotEmpty) {
          await chatQuery.docs.first.reference.update({
            'participantIds': FieldValue.arrayUnion([userId]),
          });
        }
      } catch (e) {
        // Ignore chat join error to not fail booking
        // Ignore chat join error to not fail booking
      }

      return BookingResult.success();
    } catch (e) {
      return BookingResult.failure(e.toString());
    }
  }

  Future<BookingResult> cancelBooking({
    required String slotId,
    required String userId,
    required String clubId,
  }) async {
    try {
      final slot = await _slotRepository.getSlotById(slotId);
      if (slot == null) {
        return BookingResult.failure('clubs.slot.error_not_found'.tr());
      }

      if (!slot.participants.contains(userId)) {
        return BookingResult.failure('clubs.slot.error_not_booked'.tr());
      }

      if (slot.isPast) {
        return BookingResult.failure('clubs.slot.error_cancel_past'.tr());
      }

      final success = await _slotRepository.cancelBooking(slotId, userId);
      if (!success) {
        return BookingResult.failure('clubs.slot.error_cancellation_failed'.tr());
      }

      final membership = await _membershipRepository.getMembership(
        userId,
        clubId,
      );
      if (membership != null) {
        await _membershipRepository.removeBookedSlot(membership.id, slotId);
      }

      return BookingResult.success();
    } catch (e) {
      return BookingResult.failure(e.toString());
    }
  }

  Future<List<SlotEntity>> getUserBookedSlots(String userId) async {
    final memberships = await _membershipRepository.getUserMemberships(userId);
    final List<SlotEntity> allSlots = [];

    for (final membership in memberships) {
      for (final slotId in membership.bookedSlots) {
        final slot = await _slotRepository.getSlotById(slotId);
        if (slot != null && slot.isUpcoming) {
          allSlots.add(slot);
        }
      }
    }

    allSlots.sort((a, b) => a.startTime.compareTo(b.startTime));
    return allSlots;
  }
}

class BookingResult {
  final bool isSuccess;
  final String? errorMessage;

  BookingResult.success() : isSuccess = true, errorMessage = null;

  BookingResult.failure(this.errorMessage) : isSuccess = false;
}
