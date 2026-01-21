import 'package:flutter/material.dart';
import 'package:coco/src/features/filters/domain/models/city.dart';

@immutable
class EventFilterState {
  final String? selectedSport;
  final DateTime? selectedDate;
  final bool isAroundMe;
  final City? selectedCity;
  final double radius;
  final double? deviceLat;
  final double? deviceLng;

  const EventFilterState({
    this.selectedSport,
    this.selectedDate,
    this.isAroundMe = true,
    this.selectedCity,
    this.radius = 50.0,
    this.deviceLat,
    this.deviceLng,
  });

  EventFilterState copyWith({
    String? selectedSport,
    bool clearSport = false,
    DateTime? selectedDate,
    bool clearDate = false,
    bool? isAroundMe,
    City? selectedCity,
    bool clearCity = false,
    double? radius,
    double? deviceLat,
    double? deviceLng,
  }) {
    return EventFilterState(
      selectedSport: clearSport ? null : (selectedSport ?? this.selectedSport),
      selectedDate: clearDate ? null : (selectedDate ?? this.selectedDate),
      isAroundMe: isAroundMe ?? this.isAroundMe,
      selectedCity: clearCity ? null : (selectedCity ?? this.selectedCity),
      radius: radius ?? this.radius,
      deviceLat: deviceLat ?? this.deviceLat,
      deviceLng: deviceLng ?? this.deviceLng,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventFilterState &&
        other.selectedSport == selectedSport &&
        other.selectedDate == selectedDate &&
        other.isAroundMe == isAroundMe &&
        other.selectedCity == selectedCity &&
        other.radius == radius &&
        other.deviceLat == deviceLat &&
        other.deviceLng == deviceLng;
  }

  @override
  int get hashCode => Object.hash(
    selectedSport,
    selectedDate,
    isAroundMe,
    selectedCity,
    radius,
    deviceLat,
    deviceLng,
  );
}
