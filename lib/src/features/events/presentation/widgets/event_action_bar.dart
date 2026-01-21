import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 150),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.delete_outline_rounded),
                label: Text(tr('events.delete')),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateEventScreen(eventToEdit: event),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.edit_rounded),
                label: Text(tr('common.edit')),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 150),
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
        child: ElevatedButton(
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
          style: ElevatedButton.styleFrom(
            backgroundColor: isJoined
                ? Colors.red.shade50
                : Theme.of(context).primaryColor,
            foregroundColor: isJoined ? Colors.red : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Text(
            isJoined
                ? tr('events.leave')
                : isFull
                ? tr('events.full')
                : tr('events.join'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
