import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:easy_localization/easy_localization.dart';

class SortFilterSection extends StatelessWidget {
  final bool sortByProximity;
  final Function(bool) onSortChanged;

  const SortFilterSection({
    super.key,
    required this.sortByProximity,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Text(
            tr('filters.sort_by'),
            style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: Text(tr('filters.proximity')),
                  selected: sortByProximity,
                  onSelected: (selected) {
                    if (selected) onSortChanged(true);
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color: sortByProximity ? Colors.white : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  showCheckmark: false,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ChoiceChip(
                  label: Text(tr('filters.date')),
                  selected: !sortByProximity,
                  onSelected: (selected) {
                    if (selected) onSortChanged(false);
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color: !sortByProximity ? Colors.white : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  showCheckmark: false,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
