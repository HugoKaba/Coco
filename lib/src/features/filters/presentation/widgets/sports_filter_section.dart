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
    "Fitness",
    "Crossfit",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSports = ref.watch(
      filterProvider.select((s) => s.selectedSports),
    );
    final notifier = ref.read(filterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sports",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _allSports.map((sport) {
              final isSelected = selectedSports.contains(sport);
              return GestureDetector(
                onTap: () => notifier.toggleSport(sport),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFD4913D).withValues(alpha: 0.1)
                        : Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFD4913D)
                          : Theme.of(
                              context,
                            ).dividerColor.withValues(alpha: 0.1),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    sport,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFFD4913D)
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
