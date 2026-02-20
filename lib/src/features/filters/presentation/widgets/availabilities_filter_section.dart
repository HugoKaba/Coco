import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/filter_state_provider.dart';
import '../../application/seeder_constants.dart';
import '../../../../core/data/reference_tables.dart';

class AvailabilitiesFilterSection extends ConsumerWidget {
  const AvailabilitiesFilterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDays = ref.watch(
      filterProvider.select((s) => s.selectedAvailabilities),
    );
    final notifier = ref.read(filterProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('filters.availabilities'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: SeederConstants.days.map((dayId) {
            final dayKey = ReferenceTables.getDayName(dayId);
            final dayShortKey = dayKey.replaceFirst('days.', 'days.short.');
            final isSelected = selectedDays.contains(dayId);

            return _buildDayItem(
              context,
              tr(dayShortKey),
              isSelected,
              () => notifier.toggleAvailability(dayId),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDayItem(
    BuildContext context,
    String dayText,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            dayText,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFFD4913D)
                  : Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFD4913D) : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFD4913D)
                    : Theme.of(context).dividerColor.withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
