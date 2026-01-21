import '../models/event_entity.dart';

import '../models/event_filter_state.dart';

abstract class EventsRepository {
  Future<List<EventEntity>> getEvents({EventFilterState? filter, int? limit});

  Future<void> createEvent(EventEntity event);

  Future<void> joinEvent(String eventId, String userId);

  Future<void> leaveEvent(String eventId, String userId);

  Future<List<EventEntity>> getMyEvents(String userId);

  Future<List<EventEntity>> getJoinedEvents(String userId);

  Future<void> deleteEvent(String eventId);

  Future<void> updateEvent(EventEntity event);
}
