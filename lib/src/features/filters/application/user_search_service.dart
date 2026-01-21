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
    final authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _loadData();
      }
    });
    ref.onDispose(() => authSub.cancel());

    return const UserSearchState(isLoading: true);
  }

  Future<void> _loadData() async {
    try {
      final cityString = await rootBundle.loadString(
        'assets/city/villes_idf.json',
      );
      final cities =
          (json.decode(cityString) as List)
              .map((e) => City.fromJson(e))
              .toList()
            ..sort((a, b) => a.name.compareTo(b.name));

      final pos = await LocationHelper.initLocation();
      if (pos != null) {
        ref
            .read(filterProvider.notifier)
            .setDeviceLocation(pos.latitude, pos.longitude);
      } else {
        ref.read(filterProvider.notifier).setDeviceLocation(48.8566, 2.3522);
      }

      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final swipeSub = FirebaseFirestore.instance
          .collection('users_test')
          .doc(userId)
          .collection('swipes')
          .snapshots()
          .listen((swipeSnapshot) {
            final swipedIds = swipeSnapshot.docs.map((doc) => doc.id).toSet();
            _updateUsers(userId, swipedIds, cities);
          });
      ref.onDispose(() => swipeSub.cancel());

      final userSub = FirebaseFirestore.instance
          .collection('users_test')
          .snapshots()
          .listen((userSnapshot) async {
            final swipedIds = await _swipeRepo.getSwipedUserIds(userId);
            _cachedDocs = userSnapshot.docs;
            _updateUsers(userId, swipedIds.toSet(), cities);
          });
      ref.onDispose(() => userSub.cancel());

      state = state.copyWith(isLoading: false, allCities: cities);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  List<QueryDocumentSnapshot> _cachedDocs = [];

  void _updateUsers(String userId, Set<String> swipedIds, List<City> cities) {
    if (_cachedDocs.isEmpty) return;



    final users = _cachedDocs.map((doc) => UserMapper.fromFirestore(doc)).where(
      (u) {
        final isSwiped = swipedIds.contains(u.id);
        final isCurrentUser = u.id == userId;
        return !isSwiped && !isCurrentUser;
      },
    ).toList();

    state = state.copyWith(
      allUsers: users,
      allCities: cities.isNotEmpty ? cities : state.allCities,
    );
    performSearch(ref.read(filterProvider));
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
