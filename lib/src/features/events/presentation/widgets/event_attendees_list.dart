import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_spacing.dart';

class EventAttendeesList extends StatelessWidget {
  final List<String> attendees;
  final String currentUserId;

  const EventAttendeesList({
    super.key,
    required this.attendees,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Participants',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          children: attendees
              .map(
                (id) => Chip(
                  label: Text(id == currentUserId ? 'Moi' : 'User'),
                  avatar: const CircleAvatar(
                    child: Icon(Icons.person, size: 16),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
