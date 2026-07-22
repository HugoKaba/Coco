import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/core/theme/app_colors.dart';
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
          padding: const EdgeInsets.all(AppSpacing.xxxl),
          child: Column(
            children: [
              Icon(
                Icons.calendar_today,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'clubs.dashboard.no_slots'.tr(),
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
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat('dd').format(slot.startTime),
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: AppFontSize.xl,
                  ),
                ),
                Text(
                  DateFormat('MMM').format(slot.startTime).toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.brand,
                    fontSize: AppFontSize.xs,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.type.displayName,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: AppFontSize.md,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${DateFormat('HH:mm').format(slot.startTime)} - ${DateFormat('HH:mm').format(slot.endTime)}',
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: AppFontSize.sm),
                ),
                if (slot.level != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'clubs.dashboard.level_value'.tr(
                        namedArgs: {'level': '${slot.level}'},
                      ),
                      style: const TextStyle(
                        color: AppColors.brand,
                        fontSize: AppFontSize.xs,
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
              borderRadius: BorderRadius.circular(AppRadius.sm),
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
