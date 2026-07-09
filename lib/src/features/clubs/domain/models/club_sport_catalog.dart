class ClubSportOption {
  final String key;
  final String label;

  const ClubSportOption({required this.key, required this.label});
}

class ClubSportCatalog {
  static const List<ClubSportOption> sports = [
    ClubSportOption(key: 'tennis', label: 'Tennis'),
    ClubSportOption(key: 'padel', label: 'Padel'),
    ClubSportOption(key: 'football', label: 'Football'),
    ClubSportOption(key: 'badminton', label: 'Badminton'),
  ];

  static const String defaultSportKey = 'tennis';

  static String normalizeKey(String value) => value.trim().toLowerCase();

  static List<String> normalizeKeys(Iterable<String> values) {
    final normalized = <String>{};
    for (final value in values) {
      final key = normalizeKey(value);
      if (key.isEmpty) continue;
      if (sports.any((sport) => sport.key == key)) normalized.add(key);
    }
    return normalized.toList()..sort();
  }

  static List<String> ensureKnownKeys(Iterable<String> values) {
    final normalized = normalizeKeys(values);
    return normalized.isEmpty ? [defaultSportKey] : normalized;
  }

  static ClubSportOption? tryFromKey(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final normalized = normalizeKey(value);
    for (final sport in sports) {
      if (sport.key == normalized) return sport;
    }
    return null;
  }

  static String labelFor(String? value) {
    final sport = tryFromKey(value);
    if (sport != null) return sport.label;

    final normalized = normalizeKey(value ?? '');
    if (normalized.isEmpty) return '';
    return normalized[0].toUpperCase() + normalized.substring(1);
  }

  static List<String> labelsFor(Iterable<String> values) =>
      normalizeKeys(values).map(labelFor).toList();

  static String labelsTextFor(
    Iterable<String> values, {
    String separator = ', ',
  }) {
    return labelsFor(values).join(separator);
  }
}
