import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../swap/data/swipe_repository.dart';
import '../data/mappers/user_mapper.dart';
import '../domain/models/city.dart';
import '../domain/models/filter_criteria.dart';
import '../domain/services/geolocation_service.dart';
import '../presentation/providers/filter_state_provider.dart';
import 'location_helper.dart';
import 'search_filters.dart';
import 'user_search_state.dart';

part 'user_search_notifier_data.part.dart';
part 'user_search_notifier_filters.part.dart';

class UserSearchNotifier extends Notifier<UserSearchState> {
  final GeolocationService _geoService = const GeolocationService();
  final SwipeRepository _swipeRepo = SwipeRepository();
  List<QueryDocumentSnapshot> _cachedDocs = [];

  @override
  UserSearchState build() {
    final authSub = FirebaseAuth.instance.authStateChanges().listen((u) {
      if (u != null) _loadData();
    });
    ref.onDispose(authSub.cancel);
    return const UserSearchState(isLoading: true);
  }

  Future<void> _loadData() async {
    try {
      final cities = await _loadCities();
      await _initLocation();
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        state = state.copyWith(isLoading: false);
        return;
      }
      ref.onDispose(_listenSwipes(userId, cities).cancel);
      ref.onDispose(_listenUsers(userId, cities).cancel);
      state = state.copyWith(isLoading: false, allCities: cities);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _listenSwipes(
    String userId,
    List<City> cities,
  ) {
    return FirebaseFirestore.instance
        .collection('users_test')
        .doc(userId)
        .collection('swipes')
        .snapshots()
        .listen((snap) {
          _updateUsers(userId, snap.docs.map((d) => d.id).toSet(), cities);
        });
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _listenUsers(
    String userId,
    List<City> cities,
  ) {
    return FirebaseFirestore.instance
        .collection('users_test')
        .snapshots()
        .listen((snap) async {
          _cachedDocs = snap.docs;
          final swiped = await _swipeRepo.getSwipedUserIds(userId);
          _updateUsers(userId, swiped.toSet(), cities);
        });
  }

  void _updateUsers(String userId, Set<String> swipedIds, List<City> cities) {
    if (_cachedDocs.isEmpty) return;
    final users = _cachedDocs
        .map(UserMapper.fromFirestore)
        .where((u) => u.id != userId && !swipedIds.contains(u.id))
        .toList();
    state = state.copyWith(
      allUsers: users,
      allCities: cities.isNotEmpty ? cities : state.allCities,
    );
    performSearch(ref.read(filterProvider));
  }

  Future<List<City>> _loadCities() => _loadCitiesData();
  Future<void> _initLocation() => _initUserLocation(this);
  void onSearchCityChanged(String query) => _onSearchCityChanged(this, query);
  void selectCity(City city) => _selectCity(this, city);
  void clearCity() => _clearCity(this);
  void performSearch(FilterCriteria criteria) => _performSearch(this, criteria);
}

final userSearchProvider =
    NotifierProvider<UserSearchNotifier, UserSearchState>(
      UserSearchNotifier.new,
    );
