import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/filter_state_provider.dart';
import '../../application/seeder_constants.dart';
import '../../../../core/data/reference_tables.dart';

class SportsFilterSection extends ConsumerWidget {
  const SportsFilterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSports = ref.watch(
      filterProvider.select((s) => s.selectedSports),
    );
    final notifier = ref.read(filterProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('filters.sports'),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: SeederConstants.sports.map((sport) {
            final sportId = sport['id'] as int;
            final isSelected = selectedSports.contains(sportId);
            final sportName = ReferenceTables.getSportName(sportId);

            return GestureDetector(
              onTap: () => notifier.toggleSport(sportId),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.brand.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.brand
                        : Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  tr(sportName),
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.brand
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
