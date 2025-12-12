import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filter_state_provider.dart';

class AvailabilitiesFilterSection extends ConsumerWidget {
  const AvailabilitiesFilterSection({super.key});

  static const List<String> _allDays = [
    "Lundi",
    "Mardi",
    "Mercredi",
    "Jeudi",
    "Vendredi",
    "Samedi",
    "Dimanche",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAvailabilities = ref.watch(
      filterProvider.select((s) => s.selectedAvailabilities),
    );
    final notifier = ref.read(filterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Disponibilités",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _allDays.map((day) {
              final isSelected = selectedAvailabilities.contains(day);
              return FilterChip(
                label: Text(day),
                selected: isSelected,
                onSelected: (_) => notifier.toggleAvailability(day),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
