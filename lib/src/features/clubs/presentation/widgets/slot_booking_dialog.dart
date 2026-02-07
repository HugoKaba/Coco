import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/slot_entity.dart';
import '../../application/club_providers.dart';

class SlotBookingDialog extends ConsumerWidget {
  final SlotEntity slot;
  final String clubId;

  const SlotBookingDialog({
    super.key,
    required this.slot,
    required this.clubId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              slot.type.displayName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, MMM dd • HH:mm').format(slot.startTime),
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            _buildInfoRow(
              Icons.people,
              'clubs.slot.participants',
              '${slot.participants.length}/${slot.maxParticipants}',
            ),
            if (slot.level != null)
              _buildInfoRow(Icons.trending_up, 'clubs.slot.level', slot.level!),
            if (slot.ageGroup != null)
              _buildInfoRow(Icons.cake, 'clubs.slot.age_group', slot.ageGroup!),
            const SizedBox(height: 24),
            if (slot.isFull)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange.shade800),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'clubs.slot.full'.tr(),
                        style: TextStyle(color: Colors.orange.shade800),
                      ),
                    ),
                  ],
                ),
              )
            else if (userId != null && slot.participants.contains(userId))
              _buildActionButton(
                context,
                ref,
                label: 'clubs.slot.cancel_booking'.tr(),
                color: Colors.red,
                onPressed: () => _cancelBooking(context, ref, userId),
              )
            else
              _buildActionButton(
                context,
                ref,
                label: 'clubs.slot.book'.tr(),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () => _bookSlot(context, ref, userId),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String labelKey, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(labelKey.tr(), style: TextStyle(color: Colors.grey.shade600)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _bookSlot(
    BuildContext context,
    WidgetRef ref,
    String? userId,
  ) async {
    if (userId == null) return;

    Navigator.pop(context);
    final bookingService = ref.read(clubBookingServiceProvider);
    final result = await bookingService.bookSlot(
      slotId: slot.id,
      userId: userId,
      clubId: clubId,
    );

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
    String userId,
  ) async {
    Navigator.pop(context);
    final bookingService = ref.read(clubBookingServiceProvider);
    final result = await bookingService.cancelBooking(
      slotId: slot.id,
      userId: userId,
      clubId: clubId,
    );

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
}
