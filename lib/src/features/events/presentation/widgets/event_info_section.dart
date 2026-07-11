import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/features/events/domain/models/event_entity.dart';
import 'package:coco/src/features/events/presentation/widgets/event_attendees_list.dart';

class EventInfoSection extends StatelessWidget {
  final EventEntity event;

  const EventInfoSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat(
      'EEEE d MMMM, HH:mm',
      context.locale.toString(),
    );

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: const TextStyle(
              fontSize: AppFontSize.xxxl,
              fontWeight: FontWeight.bold,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildInfoRow(
            context,
            Icons.calendar_today_rounded,
            dateFormat.format(event.date),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(
            context,
            Icons.location_on_rounded,
            event.locationName ?? tr('events.location_unknown'),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(context, Icons.sports_soccer_rounded, event.sport),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            tr('events.description'),
            style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            event.description,
            style: TextStyle(
              fontSize: AppFontSize.md,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            '${tr('events.participants')} (${event.attendees.length}/${event.maxPlaces})',
            style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          EventAttendeesList(attendees: event.attendees, currentUserId: ''),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
