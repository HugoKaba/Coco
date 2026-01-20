import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/city.dart';
import '../domain/models/filter_criteria.dart';
import '../domain/services/geolocation_service.dart';
import '../presentation/providers/filter_state_provider.dart';
import '../../swap/data/swipe_repository.dart';
import '../data/mappers/user_mapper.dart';
import 'user_search_state.dart';
import 'location_helper.dart';
import 'search_filters.dart';

class UserSearchNotifier extends Notifier<UserSearchState> {
  final GeolocationService _geoService = const GeolocationService();
  final SwipeRepository _swipeRepo = SwipeRepository();

  @override
  UserSearchState build() {
    Future.microtask(() => _loadData());
    return const UserSearchState(isLoading: true);
  }

  Future<void> _loadData() async {
    try {
      final cityString = await rootBundle.loadString(
        'assets/city/villes_idf.json',
      );
      state = state.copyWith(
        allCities:
            (json.decode(cityString) as List)
                .map((e) => City.fromJson(e))
                .toList()
              ..sort((a, b) => a.name.compareTo(b.name)),
      );

      final pos = await LocationHelper.initLocation();
      if (pos != null) {
        ref
            .read(filterProvider.notifier)
            .setDeviceLocation(pos.latitude, pos.longitude);
      } else {
        ref.read(filterProvider.notifier).setDeviceLocation(48.8566, 2.3522);
      }

      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'user_test_me';
      final swipedIds = await _swipeRepo.getSwipedUserIds(userId);
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users_test')
          .get();

      state = state.copyWith(
        allUsers: userSnapshot.docs
            .map((doc) => UserMapper.fromFirestore(doc))
            .where((u) => !swipedIds.contains(u.id) && u.id != userId)
            .toList(),
        isLoading: false,
      );
      performSearch(ref.read(filterProvider));
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void onSearchCityChanged(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredCities: []);
      return;
    }
    final q = removeDiacritics(query.toLowerCase());
    final matches = state.allCities
        .where(
          (c) =>
              c.normalizedName.contains(q) ||
              c.zipCodes.any((z) => z.startsWith(q)),
        )
        .toList();
    matches.sort(
      (a, b) =>
          a.normalizedName.startsWith(q) && !b.normalizedName.startsWith(q)
          ? -1
          : (b.normalizedName.startsWith(q) && !a.normalizedName.startsWith(q)
                ? 1
                : a.name.compareTo(b.name)),
    );
    state = state.copyWith(filteredCities: matches.take(50).toList());
  }

  void selectCity(City city) =>
      state = state.copyWith(selectedCity: city, filteredCities: []);
  void clearCity() =>
      state = state.copyWith(clearSelectedCity: true, filteredCities: []);

  void markAsSwiped(String userId) {
    state = state.copyWith(
      allUsers: state.allUsers.where((u) => u.id != userId).toList(),
      filteredUsers: state.filteredUsers.where((u) => u.id != userId).toList(),
    );
  }

  void performSearch(FilterCriteria criteria) {
    final lat = criteria.isAroundMe
        ? criteria.deviceLat
        : state.selectedCity?.lat;
    final lng = criteria.isAroundMe
        ? criteria.deviceLng
        : state.selectedCity?.lng;
    if (lat == null || lng == null) {
      state = state.copyWith(filteredUsers: []);
      return;
    }
    state = state.copyWith(
      filteredUsers: SearchFilters.apply(
        state.allUsers,
        criteria,
        lat,
        lng,
        _geoService,
      ),
    );
  }
}

final userSearchProvider =
    NotifierProvider<UserSearchNotifier, UserSearchState>(
      () => UserSearchNotifier(),
    );
