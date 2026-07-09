import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:coco/src/features/clubs/domain/models/slot_entity.dart';

class ClubDashboardSlotsSliver extends StatelessWidget {
  const ClubDashboardSlotsSliver({super.key, required this.slots});

  final List<SlotEntity> slots;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Icons.calendar_today,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'Aucun créneau prévu',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _slotCard(context, slots[index]),
        childCount: slots.length,
      ),
    );
  }

  Widget _slotCard(BuildContext context, SlotEntity slot) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat('dd').format(slot.startTime),
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  DateFormat('MMM').format(slot.startTime).toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFCD8232),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.type.displayName,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateFormat('HH:mm').format(slot.startTime)} - ${DateFormat('HH:mm').format(slot.endTime)}',
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                ),
                if (slot.level != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Niveau: ${slot.level}',
                      style: const TextStyle(
                        color: Color(0xFFCD8232),
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: (slot.isFull ? Colors.red : Colors.green).withValues(
                alpha: 0.2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${slot.participants.length}/${slot.maxParticipants}',
              style: TextStyle(
                color: slot.isFull ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
