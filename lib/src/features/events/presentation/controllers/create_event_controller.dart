import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/core/providers.dart';
import 'package:coco/src/features/events/application/events_service.dart';
import 'package:coco/src/features/events/domain/models/event_entity.dart';
import 'package:coco/src/features/filters/application/location_helper.dart';

class CreateEventController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required EventEntity? eventToEdit,
    required String title,
    required String description,
    required String locationName,
    required String sport,
    required DateTime date,
    required TimeOfDay time,
    required int maxPlaces,
    required String? imageUrl,
  }) async {
    state = const AsyncValue.loading();
    try {
      final eventDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      final user = ref.read(authStateChangesProvider).value;
      if (user == null) throw Exception('User not authenticated');

      final locations = await AppLocationHelper.getCoordinatesFromAddress(
        locationName,
      );

      if (locations.isEmpty) {
        throw Exception(tr('errors.address_not_found'));
      }

      if (eventToEdit != null) {
        final updatedEvent = eventToEdit.copyWith(
          title: title,
          description: description,
          sport: sport,
          date: eventDate,
          locationName: locationName,
          lat: locations.first.latitude,
          lng: locations.first.longitude,
          maxPlaces: maxPlaces,
          imageUrl: imageUrl,
        );
        await ref
            .read(eventsServiceProvider.notifier)
            .updateEvent(updatedEvent);
      } else {
        final newEvent = EventEntity(
          id: const Uuid().v4(),
          creatorId: user.uid,
          title: title,
          description: description,
          sport: sport,
          date: eventDate,
          locationName: locationName,
          lat: locations.first.latitude,
          lng: locations.first.longitude,
          maxPlaces: maxPlaces,
          attendees: [user.uid],
          createdAt: DateTime.now(),
          imageUrl: imageUrl,
        );
        await ref.read(eventsServiceProvider.notifier).createEvent(newEvent);
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final createEventControllerProvider =
    AsyncNotifierProvider.autoDispose<CreateEventController, void>(
      CreateEventController.new,
    );
