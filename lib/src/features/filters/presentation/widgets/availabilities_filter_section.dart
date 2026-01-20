import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filter_state_provider.dart';

class AvailabilitiesFilterSection extends ConsumerWidget {
  const AvailabilitiesFilterSection({super.key});

  static const List<String> _allDays = [
    "Lun",
    "Mar",
    "Mer",
    "Jeu",
    "Ven",
    "Sam",
    "Dim",
  ];

  static const List<String> _fullDays = [
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
    final selected = ref.watch(
      filterProvider.select((s) => s.selectedAvailabilities),
    );
    final notifier = ref.read(filterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Disponibilités",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_allDays.length, (index) {
              final day = _allDays[index];
              final fullDay = _fullDays[index];
              final isSelected = selected.contains(fullDay);

              return GestureDetector(
                onTap: () => notifier.toggleAvailability(fullDay),
                child: Column(
                  children: [
                    Text(
                      day,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFD4913D)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFD4913D)
                              : Theme.of(
                                  context,
                                ).dividerColor.withValues(alpha: 0.1),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
