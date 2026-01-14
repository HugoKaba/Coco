import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers.dart';
import '../../application/events_service.dart';
import '../../domain/models/event_entity.dart';
import '../widgets/event_info_row.dart';
import '../widgets/event_details_header.dart';
import '../widgets/event_attendees_list.dart';
import '../widgets/event_join_button.dart';

class EventDetailsScreen extends ConsumerWidget {
  final EventEntity event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app we would probably watch the specific event by ID
    // to get live updates (attendee count etc), but for now we'll just use the entity passed.
    // Ideally we re-fetch or watch the list.
    // Let's watch the list and find this event to keep UI updated.

    final eventsAsync = ref.watch(eventsServiceProvider);

    // Find latest version of this event
    final latestEvent = eventsAsync.maybeWhen(
      data: (events) =>
          events.firstWhere((e) => e.id == event.id, orElse: () => event),
      orElse: () => event,
    );

    final user = ref.watch(authStateChangesProvider).value;
    final userId = user?.uid ?? '';

    final isCreator = latestEvent.creatorId == userId;
    final isJoined = latestEvent.attendees.contains(userId);
    final isFull = latestEvent.attendees.length >= latestEvent.maxPlaces;

    final dateFormat = DateFormat('EEEE d MMMM à HH:mm', 'fr_FR');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          EventDetailsHeader(event: latestEvent),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EventInfoRow(
                    icon: Icons.calendar_today,
                    text: dateFormat.format(latestEvent.date),
                  ),
                  const SizedBox(height: 12),
                  EventInfoRow(
                    icon: Icons.location_on,
                    text: latestEvent.locationName ?? 'Lieu non précisé',
                  ),
                  const SizedBox(height: 12),
                  EventInfoRow(
                    icon: Icons.sports,
                    text: 'Sport : ${latestEvent.sport}',
                  ),
                  const SizedBox(height: 12),
                  EventInfoRow(
                    icon: Icons.group,
                    text:
                        '${latestEvent.attendees.length} / ${latestEvent.maxPlaces} participants',
                    color: isFull ? Colors.red : null,
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    latestEvent.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                  ),
                  const SizedBox(height: 32),

                  if (!isCreator)
                    EventJoinButton(
                      isJoined: isJoined,
                      isFull: isFull,
                      onPressed: (isFull && !isJoined)
                          ? null
                          : () async {
                              final notifier = ref.read(
                                eventsServiceProvider.notifier,
                              );
                              if (isJoined) {
                                await notifier.leaveEvent(
                                  latestEvent.id,
                                  userId,
                                );
                              } else {
                                await notifier.joinEvent(
                                  latestEvent.id,
                                  userId,
                                );
                              }
                            },
                    ),

                  if (isCreator)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Vous organisez cet événement',
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),
                  EventAttendeesList(
                    attendees: latestEvent.attendees,
                    currentUserId: userId,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
