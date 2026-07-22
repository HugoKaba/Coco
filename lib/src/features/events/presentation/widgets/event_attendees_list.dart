import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/features/profile/data/profile_repository.dart';
import 'package:coco/src/features/profile/presentation/public_profile_screen.dart';

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
        Text(
          'events.participants'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: attendees
              .map((id) => _AttendeeChip(
                    userId: id,
                    isCurrentUser: id == currentUserId,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _AttendeeChip extends ConsumerWidget {
  final String userId;
  final bool isCurrentUser;

  const _AttendeeChip({required this.userId, required this.isCurrentUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isCurrentUser) {
      return Chip(
        label: Text('events.attendee_me'.tr()),
        avatar: const CircleAvatar(child: Icon(Icons.person, size: 16)),
      );
    }

    final personAsync = ref.watch(publicPersonProvider(userId));

    return personAsync.when(
      loading: () => const Chip(
        label: Text('...'),
        avatar: CircleAvatar(
          child: SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 1.5),
          ),
        ),
      ),
      error: (_, __) => Chip(
        label: Text('events.attendee_unknown'.tr()),
        avatar: const CircleAvatar(child: Icon(Icons.person, size: 16)),
      ),
      data: (person) {
        if (person == null) {
          return Chip(
            label: Text('events.attendee_unknown'.tr()),
            avatar: const CircleAvatar(child: Icon(Icons.person, size: 16)),
          );
        }
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PublicProfileScreen(
                userId: userId,
                cachedPerson: person,
              ),
            ),
          ),
          child: Chip(
            label: Text(person.firstName),
            avatar: CircleAvatar(
              backgroundImage: person.profilePhotoUrl != null
                  ? NetworkImage(person.profilePhotoUrl!)
                  : null,
              child: person.profilePhotoUrl == null
                  ? const Icon(Icons.person, size: 16)
                  : null,
            ),
          ),
        );
      },
    );
  }
}
