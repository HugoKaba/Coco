import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/event_entity.dart';
import '../../domain/repositories/events_repository.dart';
import '../../domain/models/event_filter_state.dart';
import '../../application/event_filter_extension.dart';
import 'package:coco/src/features/chats/domain/repositories/conversations_repository.dart';
import 'package:coco/src/features/chats/data/repositories/conversations_repository_impl.dart';
import 'package:coco/src/features/chats/domain/models/conversation_entity.dart';

class EventsRepositoryImpl implements EventsRepository {
  final FirebaseFirestore _firestore;
  final ConversationsRepository _conversationsRepo =
      ConversationsRepositoryImpl();

  EventsRepositoryImpl(this._firestore);

  @override
  Future<List<EventEntity>> getEvents({
    EventFilterState? filter,
    int? limit,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('events')
          .orderBy('date')
          .get();

      var events = snapshot.docs
          .map((doc) => EventEntity.fromFirestore(doc))
          .applyFilter(filter);

      if (limit != null && events.length > limit) {
        events = events.take(limit).toList();
      }

      return events;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createEvent(EventEntity event) async {
    await _firestore
        .collection('events')
        .doc(event.id)
        .set(event.toFirestore());

    try {
      await _conversationsRepo.createConversation(
        participantIds: [event.creatorId],
        type: ConversationType.event,
        eventId: event.id,
      );
    } catch (e) {
      debugPrint('Error creating event conversation: $e');
    }
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

    try {
      final conversationsSnapshot = await _firestore
          .collection('conversations')
          .where('eventId', isEqualTo: eventId)
          .where('type', isEqualTo: 'event')
          .limit(1)
          .get();

      if (conversationsSnapshot.docs.isNotEmpty) {
        await _conversationsRepo.addParticipant(
          conversationId: conversationsSnapshot.docs.first.id,
          userId: userId,
        );
      }
    } catch (e) {
      debugPrint('Error adding user to event conversation: $e');
    }
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

  @override
  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }

  @override
  Future<void> updateEvent(EventEntity event) async {
    await _firestore
        .collection('events')
        .doc(event.id)
        .update(event.toFirestore());
  }
}
