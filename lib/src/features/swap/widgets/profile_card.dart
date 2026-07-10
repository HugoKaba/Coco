import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            ProfilePhotoSection(profile: profile),
            const SizedBox(height: 16),
            _buildNameSection(context),
            const SizedBox(height: 20),
            _buildSportIcons(),
            const SizedBox(height: 24),
            InfoSection(
              title: tr('swipe.description'),
              content: profile.description,
            ),
            const SizedBox(height: 24),
            InfoSection(
              title: tr('swipe.activity_frequency'),
              content: profile.activityFrequency,
            ),
            const SizedBox(height: 24),
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
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          profile.username,
          style: TextStyle(
            fontSize: 16,
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
          padding: const EdgeInsets.symmetric(horizontal: 8),
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
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        DaysRow(availableDays: profile.availableDays),
      ],
    );
  }
}
