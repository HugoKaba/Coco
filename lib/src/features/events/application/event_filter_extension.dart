import '../domain/models/event_entity.dart';
import '../domain/models/event_filter_state.dart';
import '../../filters/application/location_helper.dart';

extension EventFilterX on Iterable<EventEntity> {
  List<EventEntity> applyFilter(EventFilterState? filter) {
    if (filter == null) return toList();

    var events = this;

    if (filter.selectedSport != null && filter.selectedSport!.isNotEmpty) {
      events = events.where((e) => e.sport == filter.selectedSport);
    }

    if (filter.selectedDate != null) {
      final start = DateTime(
        filter.selectedDate!.year,
        filter.selectedDate!.month,
        filter.selectedDate!.day,
      );
      final end = start.add(const Duration(days: 1));
      events = events.where((e) {
        return e.date.isAfter(start) && e.date.isBefore(end) ||
            e.date.isAtSameMomentAs(start);
      });
    }

    double? centerLat;
    double? centerLng;

    if (filter.isAroundMe) {
      centerLat = filter.deviceLat;
      centerLng = filter.deviceLng;
    } else if (filter.selectedCity != null) {
      if (filter.selectedCity!.lat != 0 && filter.selectedCity!.lng != 0) {
        centerLat = filter.selectedCity!.lat;
        centerLng = filter.selectedCity!.lng;
      }
    }

    if (centerLat != null && centerLng != null) {
      events = events.where((e) {
        final dist = AppLocationHelper.calculateDistance(
          centerLat!,
          centerLng!,
          e.lat,
          e.lng,
        );
        return dist <= filter.radius;
      });

      final sortedEvents = events.toList();
      sortedEvents.sort((a, b) {
        final distA = AppLocationHelper.calculateDistance(
          centerLat!,
          centerLng!,
          a.lat,
          a.lng,
        );
        final distB = AppLocationHelper.calculateDistance(
          centerLat,
          centerLng,
          b.lat,
          b.lng,
        );
        return distA.compareTo(distB);
      });
      return sortedEvents;
    }

    return events.toList();
  }
}
