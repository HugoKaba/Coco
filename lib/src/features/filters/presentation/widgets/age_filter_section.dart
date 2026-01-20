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
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tranche d'âge",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "${ageRange.start.round()} - ${ageRange.end.round()} ans",
                style: TextStyle(
                  color: const Color(0xFFD4913D),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFD4913D),
              inactiveTrackColor: const Color(
                0xFFD4913D,
              ).withValues(alpha: 0.1),
              thumbColor: Colors.white,
              overlayColor: const Color(0xFFD4913D).withValues(alpha: 0.1),
              rangeThumbShape: RoundRangeSliderThumbShape(
                enabledThumbRadius: 12,
                elevation: 4,
              ),
              trackHeight: 4,
            ),
            child: RangeSlider(
              values: ageRange,
              min: 18,
              max: 100,
              divisions: 82,
              onChanged: (v) => notifier.updateAgeRange(v),
            ),
          ),
        ],
      ),
    );
  }
}
