import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/filter_criteria.dart';

class FilterNotifier extends Notifier<FilterCriteria> {
  @override
  FilterCriteria build() {
    return const FilterCriteria();
  }

  void updateRadius(double radius) {
    state = state.copyWith(radius: radius);
  }

  void toggleAroundMe(bool isAroundMe) {
    state = state.copyWith(isAroundMe: isAroundMe);
  }

  void setDeviceLocation(double lat, double lng) {
    state = state.copyWith(deviceLat: lat, deviceLng: lng);
  }

  void toggleSport(int sportId) {
    if (state.selectedSports.contains(sportId)) {
      state = state.copyWith(
        selectedSports: state.selectedSports
            .where((s) => s != sportId)
            .toList(),
      );
    } else {
      state = state.copyWith(
        selectedSports: [...state.selectedSports, sportId],
      );
    }
  }

  void setLevel(int? levelId) {
    if (levelId == null) {
      state = state.copyWith(clearLevel: true);
    } else {
      state = state.copyWith(selectedLevel: levelId);
    }
  }

  void toggleAvailability(int dayId) {
    if (state.selectedAvailabilities.contains(dayId)) {
      state = state.copyWith(
        selectedAvailabilities: state.selectedAvailabilities
            .where((d) => d != dayId)
            .toList(),
      );
    } else {
      state = state.copyWith(
        selectedAvailabilities: [...state.selectedAvailabilities, dayId],
      );
    }
  }

  void updateAgeRange(RangeValues range) {
    state = state.copyWith(ageRange: range);
  }
}

final filterProvider = NotifierProvider<FilterNotifier, FilterCriteria>(() {
  return FilterNotifier();
});
