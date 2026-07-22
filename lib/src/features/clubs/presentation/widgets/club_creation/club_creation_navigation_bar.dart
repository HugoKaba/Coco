import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';

import 'club_creation_style.dart';

class ClubCreationNavigationBar extends StatelessWidget {
  const ClubCreationNavigationBar({
    super.key,
    required this.currentStep,
    required this.isLoading,
    required this.onPrevious,
    required this.onNextOrSubmit,
  });

  final int currentStep;
  final bool isLoading;
  final VoidCallback onPrevious;
  final VoidCallback onNextOrSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: ClubCreationStyle.background(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: isLoading ? null : onPrevious,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    side: BorderSide(color: Theme.of(context).dividerColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  ),
                  child: Text('common.previous'.tr()),
                ),
              ),
            if (currentStep > 0) const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading ? null : onNextOrSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ClubCreationStyle.accent,
                  disabledBackgroundColor: ClubCreationStyle.accent.withValues(
                    alpha: 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        currentStep < 2
                            ? 'common.next'.tr()
                            : 'clubs.create.submit'.tr(),
                        style: const TextStyle(
                          fontSize: AppFontSize.md,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
