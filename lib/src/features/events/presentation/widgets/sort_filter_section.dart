import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            tr('filters.sort_by'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(width: 12),
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
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
