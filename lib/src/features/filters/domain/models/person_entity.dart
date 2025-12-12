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

class UserSport {
  final String sportName;
  final String level;

  const UserSport({required this.sportName, required this.level});

  Map<String, dynamic> toJson() => {'sportName': sportName, 'level': level};

  factory UserSport.fromJson(Map<String, dynamic> json) {
    return UserSport(
      sportName: json['sportName'] ?? '',
      level: json['level'] ?? '',
    );
  }
}

class PersonEntity extends LocationEntity {
  final String nom;
  final String prenom;
  final String genre;
  final int age;
  final List<UserSport> sports;
  final List<String> availabilities;
  final String? description;
  final String? profilePhotoUrl;
  final int frequency;
  final String objective;

  const PersonEntity({
    required super.id,
    required this.nom,
    required this.prenom,
    required this.genre,
    required this.age,
    required super.lat,
    required super.lng,
    super.metadata,
    this.sports = const [],
    this.availabilities = const [],
    this.description,
    this.profilePhotoUrl,
    this.frequency = 0,
    this.objective = '',
  }) : super(type: 'person');

  String get fullName => '$prenom $nom';
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
