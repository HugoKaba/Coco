import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/shared/widgets/app_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/features/events/application/events_service.dart';
import 'package:coco/src/features/events/domain/models/event_entity.dart';
import 'package:coco/src/features/events/presentation/pages/create_event_screen.dart';

class EventActionBar extends ConsumerWidget {
  final EventEntity event;
  final String currentUserId;
  final VoidCallback? onDelete;

  const EventActionBar({
    super.key,
    required this.event,
    required this.currentUserId,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCreator = event.creatorId == currentUserId;
    final isJoined = event.attendees.contains(currentUserId);
    final isFull = event.attendees.length >= event.maxPlaces;

    if (isCreator) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  label: tr('events.delete'),
                  onPressed: onDelete,
                  variant: AppButtonVariant.outline,
                  color: AppColors.badge,
                  icon: Icons.delete_outline_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  label: tr('common.edit'),
                  icon: Icons.edit_rounded,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreateEventScreen(eventToEdit: event),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: AppButton(
          label: isJoined
              ? tr('events.leave')
              : isFull
              ? tr('events.full')
              : tr('events.join'),
          icon: isJoined ? Icons.close_rounded : null,
          // Rejoindre = CTA orange (design system) ; quitter = contour rouge.
          variant: isJoined
              ? AppButtonVariant.outline
              : AppButtonVariant.primary,
          color: isJoined ? AppColors.badge : null,
          onPressed: (isFull && !isJoined)
              ? null
              : () async {
                  final notifier = ref.read(eventsServiceProvider.notifier);
                  if (isJoined) {
                    await notifier.leaveEvent(event.id, currentUserId);
                  } else {
                    await notifier.joinEvent(event.id, currentUserId);
                  }
                },
        ),
      ),
    );
  }
}
