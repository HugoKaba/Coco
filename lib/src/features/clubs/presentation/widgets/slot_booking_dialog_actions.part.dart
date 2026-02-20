part of 'slot_booking_dialog.dart';

Future<void> _bookSlot(
  BuildContext context,
  WidgetRef ref,
  SlotEntity slot,
  String clubId,
  String? userId,
) async {
  if (userId == null) return;
  Navigator.pop(context);
  final result = await ref
      .read(clubBookingServiceProvider)
      .bookSlot(slotId: slot.id, userId: userId, clubId: clubId);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.isSuccess
              ? 'clubs.slot.booking_confirmed'.tr()
              : result.errorMessage ?? 'clubs.slot.booking_failed'.tr(),
        ),
        backgroundColor: result.isSuccess ? Colors.green : Colors.red,
      ),
    );
  }
}

Future<void> _cancelBooking(
  BuildContext context,
  WidgetRef ref,
  SlotEntity slot,
  String clubId,
  String userId,
) async {
  Navigator.pop(context);
  final result = await ref
      .read(clubBookingServiceProvider)
      .cancelBooking(slotId: slot.id, userId: userId, clubId: clubId);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.isSuccess
              ? 'Booking cancelled'
              : result.errorMessage ?? 'Cancellation failed',
        ),
      ),
    );
  }
}
