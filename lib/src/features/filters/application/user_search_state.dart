import '../domain/models/city.dart';
import '../domain/models/person_entity.dart';

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
