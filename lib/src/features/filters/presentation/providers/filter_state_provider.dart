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

  void toggleSport(String sport) {
    final current = List<String>.from(state.selectedSports);
    if (current.contains(sport)) {
      current.remove(sport);
    } else {
      current.add(sport);
    }
    state = state.copyWith(selectedSports: current);
  }

  void setLevel(String? level) {
    state = state.copyWith(selectedLevel: level, clearLevel: level == null);
  }

  void toggleAvailability(String day) {
    final current = List<String>.from(state.selectedAvailabilities);
    if (current.contains(day)) {
      current.remove(day);
    } else {
      current.add(day);
    }
    state = state.copyWith(selectedAvailabilities: current);
  }

  void updateAgeRange(RangeValues range) {
    state = state.copyWith(ageRange: range);
  }
}

final filterProvider = NotifierProvider<FilterNotifier, FilterCriteria>(() {
  return FilterNotifier();
});
