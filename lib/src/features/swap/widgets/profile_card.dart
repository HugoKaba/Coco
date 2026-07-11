import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/profile.dart';
import 'days_row.dart';
import 'profile_sections.dart';

class ProfileCard extends StatelessWidget {
  final Profile profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          children: [
            ProfilePhotoSection(profile: profile),
            const SizedBox(height: AppSpacing.lg),
            _buildNameSection(context),
            const SizedBox(height: AppSpacing.xl),
            _buildSportIcons(),
            const SizedBox(height: AppSpacing.xxl),
            InfoSection(
              title: tr('swipe.description'),
              content: profile.description,
            ),
            const SizedBox(height: AppSpacing.xxl),
            InfoSection(
              title: tr('swipe.activity_frequency'),
              content: profile.activityFrequency,
            ),
            const SizedBox(height: AppSpacing.xxl),
            _buildDailyPreferenceSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNameSection(BuildContext context) {
    return Column(
      children: [
        Text(
          profile.name,
          style: const TextStyle(fontSize: AppFontSize.xxl, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          profile.username,
          style: TextStyle(
            fontSize: AppFontSize.md,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSportIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: profile.sports.map((sport) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            message: '${tr(sport.name)} - ${tr(sport.level)}',
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: sport.color, width: 2),
              ),
              child: Icon(sport.icon, color: sport.color, size: 28),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDailyPreferenceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('swipe.daily_preference'),
          style: TextStyle(
            fontSize: AppFontSize.sm,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        DaysRow(availableDays: profile.availableDays),
      ],
    );
  }
}
