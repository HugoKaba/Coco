import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/event_entity.dart';
import '../../domain/repositories/events_repository.dart';

class EventsRepositoryImpl implements EventsRepository {
  final FirebaseFirestore _firestore;

  EventsRepositoryImpl(this._firestore);

  @override
  Future<List<EventEntity>> getEvents({
    String? sport,
    DateTime? date,
    int? limit,
  }) async {
    Query query = _firestore.collection('events').orderBy('date');

    if (sport != null && sport.isNotEmpty) {
      query = query.where('sport', isEqualTo: sport);
    }

    if (date != null) {
      final start = DateTime(date.year, date.month, date.day);
      final end = start.add(const Duration(days: 1));
      query = query
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThan: Timestamp.fromDate(end));
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => EventEntity.fromFirestore(doc)).toList();
  }

  @override
  Future<void> createEvent(EventEntity event) async {
    await _firestore.collection('events').add(event.toFirestore());
  }

  @override
  Future<void> joinEvent(String eventId, String userId) async {
    final ref = _firestore.collection('events').doc(eventId);
    await _firestore.runTransaction((transaction) async {
      final snap = await transaction.get(ref);
      if (!snap.exists) throw Exception('Event not found');

      final event = EventEntity.fromFirestore(snap);
      if (event.attendees.contains(userId)) return;

      if (event.attendees.length >= event.maxPlaces) {
        throw Exception('Event is full');
      }

      transaction.update(ref, {
        'attendees': FieldValue.arrayUnion([userId]),
      });
    });
  }

  @override
  Future<void> leaveEvent(String eventId, String userId) async {
    await _firestore.collection('events').doc(eventId).update({
      'attendees': FieldValue.arrayRemove([userId]),
    });
  }

  @override
  Future<List<EventEntity>> getMyEvents(String userId) async {
    final snapshot = await _firestore
        .collection('events')
        .where('creatorId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => EventEntity.fromFirestore(doc)).toList();
  }

  @override
  Future<List<EventEntity>> getJoinedEvents(String userId) async {
    final snapshot = await _firestore
        .collection('events')
        .where('attendees', arrayContains: userId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => EventEntity.fromFirestore(doc)).toList();
  }
}
