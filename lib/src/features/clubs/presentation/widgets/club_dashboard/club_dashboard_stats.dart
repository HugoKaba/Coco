import 'package:flutter/material.dart';
import 'package:coco/src/features/clubs/domain/models/slot_entity.dart';

class ClubDashboardStats extends StatelessWidget {
  const ClubDashboardStats({super.key, required this.slots});

  final List<SlotEntity> slots;

  @override
  Widget build(BuildContext context) {
    final bookedCount = slots.fold<int>(
      0,
      (sum, slot) => sum + slot.participants.length,
    );
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: _card(context, 'Total Créneaux', '${slots.length}')),
          const SizedBox(width: 16),
          Expanded(child: _card(context, 'Participants', '$bookedCount')),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, String label, String value) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
