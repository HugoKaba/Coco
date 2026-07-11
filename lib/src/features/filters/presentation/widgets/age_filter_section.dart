import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filter_state_provider.dart';

class AgeFilterSection extends ConsumerWidget {
  const AgeFilterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ageRange = ref.watch(filterProvider.select((s) => s.ageRange));
    final notifier = ref.read(filterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
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
                  color: AppColors.brand,
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSize.sm,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.brand,
              inactiveTrackColor: AppColors.brand.withValues(alpha: 0.1),
              thumbColor: Colors.white,
              overlayColor: AppColors.brand.withValues(alpha: 0.1),
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
