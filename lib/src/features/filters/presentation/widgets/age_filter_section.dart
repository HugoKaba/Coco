import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filter_state_provider.dart';

class AgeFilterSection extends ConsumerWidget {
  const AgeFilterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ageRange = ref.watch(filterProvider.select((s) => s.ageRange));
    final notifier = ref.read(filterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Âge",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          RangeSlider(
            values: ageRange,
            min: 18,
            max: 100,
            divisions: 82,
            labels: RangeLabels(
              "${ageRange.start.round()}",
              "${ageRange.end.round()}",
            ),
            onChanged: (v) => notifier.updateAgeRange(v),
          ),
        ],
      ),
    );
  }
}
