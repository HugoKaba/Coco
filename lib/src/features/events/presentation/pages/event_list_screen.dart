import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../application/events_service.dart';
import '../../domain/models/event_entity.dart';
import 'create_event_screen.dart';
import 'event_details_screen.dart';
import 'my_events_screen.dart';

class EventListScreen extends ConsumerStatefulWidget {
  const EventListScreen({super.key});

  @override
  ConsumerState<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends ConsumerState<EventListScreen> {
  String? _selectedSport;

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Événements'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyEventsScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateEventScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _buildSportFilters(),
          Expanded(
            child: eventsAsync.when(
              data: (events) {
                final filtered = _selectedSport == null
                    ? events
                    : events.where((e) => e.sport == _selectedSport).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('Aucun événement trouvé.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final event = filtered[index];
                    return _EventTile(event: event);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erreur: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportFilters() {
    final sports = ['Football', 'Tennis', 'Padel', 'Running', 'Basketball'];
    return SizedBox(
      height: 60,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemCount: sports.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            final isSelected = _selectedSport == null;
            return ChoiceChip(
              label: const Text('Tout'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedSport = null);
                  ref.read(eventsServiceProvider.notifier).loadEvents();
                }
              },
            );
          }
          final sport = sports[index - 1];
          final isSelected = _selectedSport == sport;
          return ChoiceChip(
            label: Text(sport),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                setState(() => _selectedSport = sport);
                ref
                    .read(eventsServiceProvider.notifier)
                    .loadEvents(sport: sport);
              }
            },
          );
        },
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final EventEntity event;

  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM HH:mm');
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsScreen(event: event),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                image: event.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(event.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: event.imageUrl == null
                  ? const Center(
                      child: Icon(Icons.event, size: 40, color: Colors.grey),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.sport.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        dateFormat.format(event.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.locationName ?? 'Lieu inconnu',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.group, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '${event.attendees.length} / ${event.maxPlaces}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
