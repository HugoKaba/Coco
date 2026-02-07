class ClubFilterCriteria {
  final bool isAroundMe;
  final String? cityName;
  final double? cityLat;
  final double? cityLng;
  final double? deviceLat;
  final double? deviceLng;
  final Set<String> selectedSports;
  final Set<String> selectedLevels;
  final double radiusKm;

  const ClubFilterCriteria({
    this.isAroundMe = true,
    this.cityName,
    this.cityLat,
    this.cityLng,
    this.deviceLat,
    this.deviceLng,
    this.selectedSports = const {},
    this.selectedLevels = const {},
    this.radiusKm = 10.0,
    this.minAge,
    this.maxAge,
  });

  final double? minAge;
  final double? maxAge;

  ClubFilterCriteria copyWith({
    bool? isAroundMe,
    String? cityName,
    double? cityLat,
    double? cityLng,
    double? deviceLat,
    double? deviceLng,
    Set<String>? selectedSports,
    Set<String>? selectedLevels,
    double? radiusKm,
    double? minAge,
    double? maxAge,
  }) {
    return ClubFilterCriteria(
      isAroundMe: isAroundMe ?? this.isAroundMe,
      cityName: cityName ?? this.cityName,
      cityLat: cityLat ?? this.cityLat,
      cityLng: cityLng ?? this.cityLng,
      deviceLat: deviceLat ?? this.deviceLat,
      deviceLng: deviceLng ?? this.deviceLng,
      selectedSports: selectedSports ?? this.selectedSports,
      selectedLevels: selectedLevels ?? this.selectedLevels,
      radiusKm: radiusKm ?? this.radiusKm,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
    );
  }

  double? get searchLat => isAroundMe ? deviceLat : cityLat;
  double? get searchLng => isAroundMe ? deviceLng : cityLng;
}
