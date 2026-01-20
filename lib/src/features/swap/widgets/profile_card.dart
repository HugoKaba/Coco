import 'package:flutter/material.dart';
import '../models/profile.dart';
import 'days_row.dart';
import 'profile_sections.dart';

class ProfileCard extends StatelessWidget {
  final Profile profile;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            ProfilePhotoSection(
              profile: profile,
              onLeft: onSwipeLeft,
              onRight: onSwipeRight,
            ),
            const SizedBox(height: 16),
            _buildNameSection(),
            const SizedBox(height: 20),
            _buildSportIcons(),
            const SizedBox(height: 24),
            InfoSection(title: 'Description', content: profile.description),
            const SizedBox(height: 24),
            InfoSection(
              title: "Fréquence d'activité",
              content: profile.activityFrequency,
            ),
            const SizedBox(height: 24),
            _buildDailyPreferenceSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameSection() {
    return Column(
      children: [
        Text(
          profile.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          profile.username,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
            message: sport.name,
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

  Widget _buildDailyPreferenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Préférence journalière',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        DaysRow(availableDays: profile.availableDays),
      ],
    );
  }
}
