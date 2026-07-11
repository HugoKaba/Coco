import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/core/theme/app_colors.dart';

class FilterSearchButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const FilterSearchButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: SafeArea(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            backgroundColor: AppColors.brand,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
