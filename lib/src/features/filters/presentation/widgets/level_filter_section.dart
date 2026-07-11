import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/filter_state_provider.dart';
import '../../../../core/data/reference_tables.dart';

class LevelFilterSection extends ConsumerWidget {
  const LevelFilterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLevel = ref.watch(
      filterProvider.select((s) => s.selectedLevel),
    );
    final notifier = ref.read(filterProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('filters.level'),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: AppFontSize.md,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildLevelItem(
              context,
              tr("levels.all"),
              selectedLevel == null,
              () => notifier.setLevel(null),
            ),
            ...ReferenceTables.levels.entries.map((entry) {
              return _buildLevelItem(
                context,
                tr(entry.value),
                selectedLevel == entry.key,
                () => notifier.setLevel(entry.key),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildLevelItem(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.brand.withValues(alpha: 0.1)
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: isSelected
                ? AppColors.brand
                : Theme.of(context).dividerColor.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AppColors.brand
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: AppFontSize.sm,
          ),
        ),
      ),
    );
  }
}
