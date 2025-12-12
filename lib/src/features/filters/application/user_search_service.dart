import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/city.dart';
import '../domain/models/person_entity.dart';
import '../domain/models/filter_criteria.dart';
import '../domain/services/geolocation_service.dart';
import '../presentation/providers/filter_state_provider.dart';

class UserSearchState {
  final List<City> allCities;
  final List<City> filteredCities;
  final List<PersonEntity> allUsers;
  final List<PersonEntity> filteredUsers;
  final bool isLoading;
  final City? selectedCity;

  const UserSearchState({
    this.allCities = const [],
    this.filteredCities = const [],
    this.allUsers = const [],
    this.filteredUsers = const [],
    this.isLoading = false,
    this.selectedCity,
  });

  UserSearchState copyWith({
    List<City>? allCities,
    List<City>? filteredCities,
    List<PersonEntity>? allUsers,
    List<PersonEntity>? filteredUsers,
    bool? isLoading,
    City? selectedCity,
    bool clearSelectedCity = false,
  }) {
    return UserSearchState(
      allCities: allCities ?? this.allCities,
      filteredCities: filteredCities ?? this.filteredCities,
      allUsers: allUsers ?? this.allUsers,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      isLoading: isLoading ?? this.isLoading,
      selectedCity: clearSelectedCity
          ? null
          : (selectedCity ?? this.selectedCity),
    );
  }
}

class UserSearchNotifier extends Notifier<UserSearchState> {
  final GeolocationService _geoService = const GeolocationService();

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
      final cityList = (json.decode(cityString) as List)
          .map((e) => City.fromJson(e))
          .toList();
      cityList.sort((a, b) => a.name.compareTo(b.name));

      final userString = await rootBundle.loadString(
        'assets/users/users_idf.json',
      );
      final userList = (json.decode(userString) as List).map((e) {
        final rawSports = (e['sports'] as List?) ?? [];
        final List<UserSport> userSports = [];

        if (rawSports.isNotEmpty && rawSports.first is String) {
          final lvl = e['level'] ?? 'Intermédiaire';
          for (final s in rawSports) {
            userSports.add(UserSport(sportName: s, level: lvl));
          }
        }

        final parts = (e['name'] ?? 'Unknown User').toString().split(' ');
        final prenom = parts.isNotEmpty ? parts.first : 'User';
        final nom = parts.length > 1 ? parts.sublist(1).join(' ') : '';

        return PersonEntity(
          id: e['id'],
          prenom: prenom,
          nom: nom,
          genre: e['genre'] ?? 'M',
          age: e['age'] ?? 25,
          lat: (e['latitude'] as num).toDouble(),
          lng: (e['longitude'] as num).toDouble(),
          metadata: {'city': e['city']},
          sports: userSports,
          availabilities: (e['jours'] as List?)?.cast<String>() ?? [],
        );
      }).toList();

      state = state.copyWith(
        allCities: cityList,
        allUsers: userList,
        isLoading: false,
      );

      performSearch(ref.read(filterProvider));
    } catch (e) {
      debugPrint('Error loading search data: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  void onSearchCityChanged(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredCities: []);
      return;
    }

    final q = removeDiacritics(query.toLowerCase());
    final matches = state.allCities.where((city) {
      final nameMatch = city.normalizedName.contains(q);
      final zipMatch = city.zipCodes.any((zip) => zip.startsWith(q));
      return nameMatch || zipMatch;
    }).toList();

    matches.sort((a, b) {
      final aStartsWith = a.normalizedName.startsWith(q);
      final bStartsWith = b.normalizedName.startsWith(q);
      if (aStartsWith && !bStartsWith) return -1;
      if (!aStartsWith && bStartsWith) return 1;
      return a.name.compareTo(b.name);
    });

    state = state.copyWith(filteredCities: matches.take(50).toList());
  }

  void selectCity(City city) {
    state = state.copyWith(selectedCity: city, filteredCities: []);
  }

  void clearCity() {
    state = state.copyWith(clearSelectedCity: true, filteredCities: []);
  }

  void performSearch(FilterCriteria criteria) {
    double centerLat;
    double centerLng;

    if (criteria.isAroundMe) {
      if (criteria.deviceLat == null || criteria.deviceLng == null) {
        state = state.copyWith(filteredUsers: []);
        return;
      }
      centerLat = criteria.deviceLat!;
      centerLng = criteria.deviceLng!;
    } else {
      if (state.selectedCity == null) {
        state = state.copyWith(filteredUsers: []);
        return;
      }
      centerLat = state.selectedCity!.lat;
      centerLng = state.selectedCity!.lng;
    }

    final raw = state.allUsers;
    final out = <MapEntry<PersonEntity, double>>[];

    for (final p in raw) {
      final d = _geoService.distanceMeters(centerLat, centerLng, p.lat, p.lng);
      if (d > criteria.radius) {
        continue;
      }

      bool sportMatch = true;
      if (criteria.selectedSports.isNotEmpty) {
        final matchingUserSports = p.sports
            .where((us) => criteria.selectedSports.contains(us.sportName))
            .toList();

        if (matchingUserSports.isEmpty) {
          sportMatch = false;
        } else {
          if (criteria.selectedLevel != null) {
            final levelMatch = matchingUserSports.any(
              (us) => us.level == criteria.selectedLevel,
            );
            if (!levelMatch) sportMatch = false;
          }
        }
      } else {
        if (criteria.selectedLevel != null) {
          if (!p.sports.any((us) => us.level == criteria.selectedLevel)) {
            sportMatch = false;
          }
        }
      }

      if (!sportMatch) continue;

      if (criteria.selectedAvailabilities.isNotEmpty) {
        if (!p.availabilities.any(
          (a) => criteria.selectedAvailabilities.contains(a),
        )) {
          continue;
        }
      }

      if (p.age < criteria.ageRange.start || p.age > criteria.ageRange.end) {
        continue;
      }

      out.add(MapEntry(p, d));
    }

    out.sort((a, b) => a.value.compareTo(b.value));
    state = state.copyWith(filteredUsers: out.map((e) => e.key).toList());
  }
}

final userSearchProvider =
    NotifierProvider<UserSearchNotifier, UserSearchState>(() {
      return UserSearchNotifier();
    });
