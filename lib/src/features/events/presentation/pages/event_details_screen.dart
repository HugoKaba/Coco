import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/core/providers.dart';
import 'package:coco/src/features/events/application/events_service.dart';
import 'package:coco/src/features/events/domain/models/event_entity.dart';
import 'package:coco/src/features/events/presentation/widgets/event_details_header.dart';
import 'package:coco/src/features/events/presentation/widgets/event_info_section.dart';
import 'package:coco/src/features/events/presentation/widgets/event_action_bar.dart';

class EventDetailsScreen extends ConsumerWidget {
  final EventEntity event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsServiceProvider);
    final latestEvent = eventsAsync.maybeWhen(
      data: (events) =>
          events.firstWhere((e) => e.id == event.id, orElse: () => event),
      orElse: () => event,
    );

    final user = ref.watch(authStateChangesProvider).value;
    final userId = user?.uid ?? '';
    final isCreator = latestEvent.creatorId == userId;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          EventDetailsHeader(
            event: latestEvent,
            isCreator: isCreator,
            onDelete: () => _confirmDelete(context, ref, latestEvent.id),
          ),
          SliverToBoxAdapter(child: EventInfoSection(event: latestEvent)),
        ],
      ),
      bottomNavigationBar: EventActionBar(
        event: latestEvent,
        currentUserId: userId,
        onDelete: () => _confirmDelete(context, ref, latestEvent.id),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String eventId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr('events.delete')),
        content: Text(tr('events.delete_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr('common.cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(tr('events.delete')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(eventsServiceProvider.notifier).deleteEvent(eventId);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(tr('events.deleted'))));
      }
    }
  }
}
