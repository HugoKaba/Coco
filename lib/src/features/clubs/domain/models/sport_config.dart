enum SportType {
  tennis,
  gym,
  football,
  athletics,
  basketball,
  volleyball,
  swimming,
  other;

  String get displayName {
    switch (this) {
      case SportType.tennis:
        return 'Tennis';
      case SportType.gym:
        return 'Gym';
      case SportType.football:
        return 'Football';
      case SportType.athletics:
        return 'Athletics';
      case SportType.basketball:
        return 'Basketball';
      case SportType.volleyball:
        return 'Volleyball';
      case SportType.swimming:
        return 'Swimming';
      case SportType.other:
        return 'Other';
    }
  }
}

class SportConfig {
  final SportType type;
  final bool supportsMultipleCourts;
  final bool supportsLevels;
  final bool supportsAgeGroups;
  final List<String> availableLevels;
  final List<String> availableAgeGroups;
  final List<String> facilityTypes;
  final Map<String, dynamic> customFields;

  const SportConfig({
    required this.type,
    required this.supportsMultipleCourts,
    required this.supportsLevels,
    required this.supportsAgeGroups,
    required this.availableLevels,
    required this.availableAgeGroups,
    required this.facilityTypes,
    required this.customFields,
  });

  static SportConfig forSport(SportType type) {
    switch (type) {
      case SportType.tennis:
        return SportConfig(
          type: type,
          supportsMultipleCourts: true,
          supportsLevels: true,
          supportsAgeGroups: true,
          availableLevels: ['Beginner', 'Intermediate', 'Advanced', 'Pro'],
          availableAgeGroups: ['Kids', 'Teens', 'Adults', 'Seniors'],
          facilityTypes: ['Court'],
          customFields: {
            'surfaceTypes': ['Clay', 'Hard', 'Grass', 'Indoor'],
            'maxPlayersPerCourt': 4,
          },
        );

      case SportType.gym:
        return SportConfig(
          type: type,
          supportsMultipleCourts: true,
          supportsLevels: true,
          supportsAgeGroups: true,
          availableLevels: ['Beginner', 'Intermediate', 'Advanced'],
          availableAgeGroups: ['Teens', 'Adults', 'Seniors'],
          facilityTypes: ['Studio', 'Main Floor', 'Cardio Area', 'Weights'],
          customFields: {
            'classTypes': ['Yoga', 'Pilates', 'CrossFit', 'Spinning', 'HIIT'],
            'requiresEquipment': true,
          },
        );

      case SportType.football:
        return SportConfig(
          type: type,
          supportsMultipleCourts: true,
          supportsLevels: true,
          supportsAgeGroups: true,
          availableLevels: ['Recreational', 'Competitive', 'Elite'],
          availableAgeGroups: ['U10', 'U13', 'U16', 'U18', 'Adults'],
          facilityTypes: ['Field'],
          customFields: {
            'gameFormats': ['5v5', '7v7', '11v11'],
            'fieldSizes': ['Small', 'Medium', 'Full'],
          },
        );

      case SportType.athletics:
        return SportConfig(
          type: type,
          supportsMultipleCourts: false,
          supportsLevels: true,
          supportsAgeGroups: true,
          availableLevels: ['Beginner', 'Intermediate', 'Advanced', 'Elite'],
          availableAgeGroups: ['Kids', 'Teens', 'Adults', 'Masters'],
          facilityTypes: ['Track', 'Field', 'Indoor'],
          customFields: {
            'disciplines': ['Sprints', 'Distance', 'Jumps', 'Throws'],
          },
        );

      default:
        return SportConfig(
          type: type,
          supportsMultipleCourts: false,
          supportsLevels: true,
          supportsAgeGroups: true,
          availableLevels: ['Beginner', 'Intermediate', 'Advanced'],
          availableAgeGroups: ['Kids', 'Adults'],
          facilityTypes: ['Main'],
          customFields: {},
        );
    }
  }
}
