// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
part of 'user_search_service.dart';

void _onSearchCityChanged(UserSearchNotifier n, String query) {
  if (query.isEmpty) {
    n.state = n.state.copyWith(filteredCities: []);
    return;
  }
  final q = removeDiacritics(query.toLowerCase());
  final matches = n.state.allCities
      .where(
        (c) =>
            c.normalizedName.contains(q) ||
            c.zipCodes.any((z) => z.startsWith(q)),
      )
      .toList();
  matches.sort(
    (a, b) => a.normalizedName.startsWith(q) && !b.normalizedName.startsWith(q)
        ? -1
        : (b.normalizedName.startsWith(q) && !a.normalizedName.startsWith(q)
              ? 1
              : a.name.compareTo(b.name)),
  );
  n.state = n.state.copyWith(filteredCities: matches.take(50).toList());
}

void _selectCity(UserSearchNotifier n, City city) {
  n.state = n.state.copyWith(selectedCity: city, filteredCities: []);
}

void _clearCity(UserSearchNotifier n) {
  n.state = n.state.copyWith(clearSelectedCity: true, filteredCities: []);
}

void _performSearch(UserSearchNotifier n, FilterCriteria criteria) {
  final lat = criteria.isAroundMe
      ? criteria.deviceLat
      : n.state.selectedCity?.lat;
  final lng = criteria.isAroundMe
      ? criteria.deviceLng
      : n.state.selectedCity?.lng;
  if (lat == null || lng == null) {
    n.state = n.state.copyWith(filteredUsers: []);
    return;
  }
  n.state = n.state.copyWith(
    filteredUsers: SearchFilters.apply(
      n.state.allUsers,
      criteria,
      lat,
      lng,
      n._geoService,
    ),
  );
}
