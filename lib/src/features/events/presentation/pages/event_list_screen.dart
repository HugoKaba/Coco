import 'package:coco/src/features/events/application/event_filter_provider.dart';
import 'package:coco/src/features/events/application/events_service.dart';
import 'package:coco/src/features/events/presentation/pages/create_event_screen.dart';
import 'package:coco/src/features/events/presentation/pages/event_details_screen.dart';
import 'package:coco/src/features/events/presentation/widgets/event_card.dart';
import 'package:coco/src/features/events/presentation/widgets/event_filter_sheet.dart';
import 'package:coco/src/features/filters/application/location_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventListScreen extends ConsumerStatefulWidget {
  const EventListScreen({super.key});
  @override
  ConsumerState<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends ConsumerState<EventListScreen> {
  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final notifier = ref.read(eventFilterProvider.notifier);
    notifier.setDeviceLocation(48.8566, 2.3522);
    try {
      final pos = await LocationHelper.initLocation();
      if (pos != null) notifier.setDeviceLocation(pos.latitude, pos.longitude);
    } catch (_) {}
    ref
        .read(eventsServiceProvider.notifier)
        .loadEvents(filter: ref.read(eventFilterProvider));
  }

  Future<void> _showFilterSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EventFilterSheet(),
    );
    ref
        .read(eventsServiceProvider.notifier)
        .loadEvents(filter: ref.read(eventFilterProvider));
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsServiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('events.title')),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showFilterSheet,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.tune_rounded,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 110),
        child: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateEventScreen()),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: eventsAsync.when(
        data: (events) => events.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_busy_rounded,
                      size: 64,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tr('events.no_events'),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 150),
                itemCount: events.length,
                itemBuilder: (_, i) {
                  final event = events[i];
                  return EventCard(
                    event: event,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailsScreen(event: event),
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(tr('events.failed_load'))),
      ),
    );
  }
}
