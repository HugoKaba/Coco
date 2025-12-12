import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filter_state_provider.dart';

class SportsFilterSection extends ConsumerWidget {
  const SportsFilterSection({super.key});

  static const List<String> _allSports = [
    "Football",
    "Tennis",
    "Padel",
    "Running",
    "Basketball",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSports = ref.watch(
      filterProvider.select((s) => s.selectedSports),
    );
    final notifier = ref.read(filterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sports",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _allSports.map((sport) {
              final isSelected = selectedSports.contains(sport);
              return FilterChip(
                label: Text(sport),
                selected: isSelected,
                onSelected: (_) => notifier.toggleSport(sport),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
