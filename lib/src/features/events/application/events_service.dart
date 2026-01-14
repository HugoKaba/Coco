import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/event_entity.dart';
import '../domain/repositories/events_repository.dart';
import '../data/repositories/events_repository_impl.dart';

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  return EventsRepositoryImpl(FirebaseFirestore.instance);
});

final eventsServiceProvider =
    StateNotifierProvider<EventsService, AsyncValue<List<EventEntity>>>((ref) {
      return EventsService(ref.read(eventsRepositoryProvider));
    });

class EventsService extends StateNotifier<AsyncValue<List<EventEntity>>> {
  final EventsRepository _repository;

  EventsService(this._repository) : super(const AsyncValue.loading()) {
    loadEvents();
  }

  Future<void> loadEvents({String? sport, DateTime? date}) async {
    try {
      state = const AsyncValue.loading();
      final events = await _repository.getEvents(sport: sport, date: date);
      state = AsyncValue.data(events);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createEvent(EventEntity event) async {
    await _repository.createEvent(event);
    loadEvents(); // Refresh list
  }

  Future<void> joinEvent(String eventId, String userId) async {
    await _repository.joinEvent(eventId, userId);
    loadEvents(); // Refresh list
  }

  Future<void> leaveEvent(String eventId, String userId) async {
    await _repository.leaveEvent(eventId, userId);
    loadEvents(); // Refresh list
  }
}

final myEventsProvider = FutureProvider.family<List<EventEntity>, String>((
  ref,
  userId,
) async {
  final repo = ref.read(eventsRepositoryProvider);
  return repo.getMyEvents(userId);
});

final joinedEventsProvider = FutureProvider.family<List<EventEntity>, String>((
  ref,
  userId,
) async {
  final repo = ref.read(eventsRepositoryProvider);
  return repo.getJoinedEvents(userId);
});
