import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class EventFilterApplyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EventFilterApplyButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    const kOrangeColor = AppColors.brand;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: kOrangeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: Text(
            tr('filters.apply'),
            style: const TextStyle(
              fontSize: AppFontSize.md,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
