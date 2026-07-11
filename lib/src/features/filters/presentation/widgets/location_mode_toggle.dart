import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import '../providers/filter_state_provider.dart';

class LocationModeToggle extends StatelessWidget {
  final bool isAroundMe;
  final FilterNotifier notifier;
  final VoidCallback onClearSearch;

  const LocationModeToggle({
    super.key,
    required this.isAroundMe,
    required this.notifier,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey.shade200
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Row(
        children: [
          Expanded(child: _buildOption(context, 'Autour de moi', true)),
          Expanded(child: _buildOption(context, 'Choisir une ville', false)),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String text, bool value) {
    final isSelected = value == isAroundMe;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        notifier.toggleAroundMe(value);
        if (value) onClearSearch();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? (Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : colorScheme.surface)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}
