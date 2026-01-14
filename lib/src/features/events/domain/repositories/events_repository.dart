import '../models/event_entity.dart';

abstract class EventsRepository {
  Future<List<EventEntity>> getEvents({
    String? sport,
    DateTime? date,
    int? limit,
  });

  Future<void> createEvent(EventEntity event);

  Future<void> joinEvent(String eventId, String userId);

  Future<void> leaveEvent(String eventId, String userId);

  Future<List<EventEntity>> getMyEvents(String userId);

  Future<List<EventEntity>> getJoinedEvents(String userId);
}
