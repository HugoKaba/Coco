import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filter_state_provider.dart';

class LevelFilterSection extends ConsumerWidget {
  const LevelFilterSection({super.key});

  static const List<String> _allLevels = [
    "Débutant",
    "Intermédiaire",
    "Confirmé",
    "Expert",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLevel = ref.watch(
      filterProvider.select((s) => s.selectedLevel),
    );
    final notifier = ref.read(filterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Niveau",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            key: ValueKey(selectedLevel),
            initialValue: selectedLevel,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),
            ),
            hint: const Text("Choisir un niveau"),
            items: [
              const DropdownMenuItem(value: null, child: Text("Tous")),
              ..._allLevels.map(
                (l) => DropdownMenuItem(value: l, child: Text(l)),
              ),
            ],
            onChanged: (v) => notifier.setLevel(v),
          ),
        ],
      ),
    );
  }
}
