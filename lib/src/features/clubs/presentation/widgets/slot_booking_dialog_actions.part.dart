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

  // Créneau payant → on règle via Stripe avant de réserver.
  final price = slot.price;
  if (price != null && price > 0) {
    try {
      final paid = await ref
          .read(stripePaymentServiceProvider)
          .payForSlot(slotId: slot.id);
      if (!paid) {
        // Paiement annulé par l'utilisateur : aucune réservation.
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('clubs.slot.payment_canceled'.tr())),
          );
        }
        return;
      }
    } on PaymentException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
      return;
    }
  }

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
