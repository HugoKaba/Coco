import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/event_filter_state.dart';
import 'package:coco/src/features/filters/domain/models/city.dart';

class EventFilterNotifier extends Notifier<EventFilterState> {
  @override
  EventFilterState build() {
    return const EventFilterState();
  }

  void setSport(String? sport) {
    state = state.copyWith(selectedSport: sport, clearSport: sport == null);
  }

  void setDate(DateTime? date) {
    state = state.copyWith(selectedDate: date, clearDate: date == null);
  }

  void toggleAroundMe(bool isAroundMe) {
    state = state.copyWith(isAroundMe: isAroundMe);
  }

  void selectCity(City? city) {
    state = state.copyWith(selectedCity: city, clearCity: city == null);
  }

  void updateRadius(double radius) {
    state = state.copyWith(radius: radius);
  }

  void setDeviceLocation(double lat, double lng) {
    state = state.copyWith(deviceLat: lat, deviceLng: lng);
  }

  void reset() {
    state = const EventFilterState();
  }
}

final eventFilterProvider =
    NotifierProvider<EventFilterNotifier, EventFilterState>(() {
      return EventFilterNotifier();
    });
