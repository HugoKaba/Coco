import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/club_providers.dart';
import '../../domain/models/slot_entity.dart';

part 'slot_booking_dialog_actions.part.dart';

class SlotBookingDialog extends ConsumerWidget {
  const SlotBookingDialog({
    super.key,
    required this.slot,
    required this.clubId,
  });
  final SlotEntity slot;
  final String clubId;

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
            _row(
              Icons.people,
              'clubs.slot.participants',
              '${slot.participants.length}/${slot.maxParticipants}',
            ),
            if (slot.level != null)
              _row(Icons.trending_up, 'clubs.slot.level', slot.level!),
            if (slot.ageGroup != null)
              _row(Icons.cake, 'clubs.slot.age_group', slot.ageGroup!),
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
              _button(
                context,
                'clubs.slot.cancel_booking'.tr(),
                Colors.red,
                () => _cancelBooking(context, ref, slot, clubId, userId),
              )
            else
              _button(
                context,
                'clubs.slot.book'.tr(),
                Theme.of(context).colorScheme.primary,
                () => _bookSlot(context, ref, slot, clubId, userId),
              ),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String labelKey, String value) => Padding(
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

  Widget _button(
    BuildContext context,
    String label,
    Color color,
    VoidCallback onPressed,
  ) => SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
