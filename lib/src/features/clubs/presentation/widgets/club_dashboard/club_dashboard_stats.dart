import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
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
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: _card(
              context,
              'clubs.dashboard.stat_total_slots'.tr(),
              '${slots.length}',
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: _card(
              context,
              'clubs.dashboard.stat_participants'.tr(),
              '$bookedCount',
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, String label, String value) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: AppFontSize.display,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: AppFontSize.xs),
          ),
        ],
      ),
    );
  }
}
