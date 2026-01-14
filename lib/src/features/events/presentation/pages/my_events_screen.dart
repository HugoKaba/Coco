import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers.dart';
import '../../application/events_service.dart';
import '../../domain/models/event_entity.dart';
import 'event_details_screen.dart';

class MyEventsScreen extends ConsumerStatefulWidget {
  const MyEventsScreen({super.key});

  @override
  ConsumerState<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends ConsumerState<MyEventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Événements'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'J\'organise'),
            Tab(text: 'Je participe'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _EventListTab(isOrganized: true),
          _EventListTab(isOrganized: false),
        ],
      ),
    );
  }
}

class _EventListTab extends ConsumerWidget {
  final bool isOrganized;

  const _EventListTab({required this.isOrganized});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final userId = user?.uid ?? '';

    final eventsAsync = isOrganized
        ? ref.watch(myEventsProvider(userId))
        : ref.watch(joinedEventsProvider(userId));

    return eventsAsync.when(
      data: (events) {
        if (events.isEmpty) {
          return Center(
            child: Text(
              isOrganized
                  ? 'Vous n\'orginisez aucun événement.'
                  : 'Vous ne participez à aucun événement.',
              style: const TextStyle(color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            return _CompactEventTile(event: events[index]);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Erreur: $err')),
    );
  }
}

class _CompactEventTile extends StatelessWidget {
  final EventEntity event;

  const _CompactEventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM HH:mm');
    return Card(
      child: ListTile(
        leading: event.imageUrl != null
            ? CircleAvatar(backgroundImage: NetworkImage(event.imageUrl!))
            : CircleAvatar(child: Text(event.sport[0])),
        title: Text(event.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('${event.sport} • ${dateFormat.format(event.date)}'),
        trailing: Text('${event.attendees.length}/${event.maxPlaces}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsScreen(event: event),
            ),
          );
        },
      ),
    );
  }
}
