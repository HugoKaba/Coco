abstract class LocationEntity {
  final String id;
  final String type;
  final double lat;
  final double lng;
  final Map<String, dynamic> metadata;

  const LocationEntity({
    required this.id,
    required this.type,
    required this.lat,
    required this.lng,
    this.metadata = const {},
  });
}

class PersonEntity extends LocationEntity {
  final String name;
  final List<String> sports;
  final String level;
  final List<String> availabilities;
  final int age;

  const PersonEntity({
    required super.id,
    required this.name,
    required super.lat,
    required super.lng,
    super.metadata,
    this.sports = const [],
    this.level = '',
    this.availabilities = const [],
    this.age = 0,
  }) : super(type: 'person');
}

class EventEntity extends LocationEntity {
  final String title;
  const EventEntity({
    required super.id,
    required this.title,
    required super.lat,
    required super.lng,
    super.metadata,
  }) : super(type: 'event');
}
