import 'package:flutter/material.dart';

class FilterCriteria {
  final bool isAroundMe;
  final double radius;
  final double? deviceLat;
  final double? deviceLng;
  final List<int> selectedSports;
  final int? selectedLevel;
  final List<int> selectedAvailabilities;
  final RangeValues ageRange;

  const FilterCriteria({
    this.isAroundMe = true,
    this.radius = 50000.0,
    this.deviceLat,
    this.deviceLng,
    this.selectedSports = const [],
    this.selectedLevel,
    this.selectedAvailabilities = const [],
    this.ageRange = const RangeValues(18, 60),
  });

  FilterCriteria copyWith({
    bool? isAroundMe,
    double? radius,
    double? deviceLat,
    double? deviceLng,
    List<int>? selectedSports,
    int? selectedLevel,
    bool clearLevel = false,
    List<int>? selectedAvailabilities,
    RangeValues? ageRange,
  }) {
    return FilterCriteria(
      isAroundMe: isAroundMe ?? this.isAroundMe,
      radius: radius ?? this.radius,
      deviceLat: deviceLat ?? this.deviceLat,
      deviceLng: deviceLng ?? this.deviceLng,
      selectedSports: selectedSports ?? this.selectedSports,
      selectedLevel: clearLevel ? null : (selectedLevel ?? this.selectedLevel),
      selectedAvailabilities:
          selectedAvailabilities ?? this.selectedAvailabilities,
      ageRange: ageRange ?? this.ageRange,
    );
  }
}
