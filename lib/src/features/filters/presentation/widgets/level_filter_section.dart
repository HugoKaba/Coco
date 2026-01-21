import 'package:flutter/material.dart';
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD4913D).withValues(alpha: 0.1)
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4913D)
                : Theme.of(context).dividerColor.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFFD4913D)
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
