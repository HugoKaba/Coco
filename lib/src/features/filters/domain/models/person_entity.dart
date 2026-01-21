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
  final int sportId;
  final int levelId;

  const UserSport({required this.sportId, required this.levelId});

  Map<String, dynamic> toJson() => {'sportId': sportId, 'levelId': levelId};

  factory UserSport.fromJson(Map<String, dynamic> json) {
    return UserSport(
      sportId: json['sportId'] ?? 0,
      levelId: json['levelId'] ?? 0,
    );
  }
}

class PersonEntity extends LocationEntity {
  final String lastName;
  final String firstName;
  final String gender;
  final int age;
  final List<UserSport> sports;
  final List<int> availabilities;
  final String? bio;
  final String? profilePhotoUrl;
  final int frequency;
  final String objective;

  const PersonEntity({
    required super.id,
    required this.lastName,
    required this.firstName,
    required this.gender,
    required this.age,
    required super.lat,
    required super.lng,
    super.metadata,
    this.sports = const [],
    this.availabilities = const [],
    this.bio,
    this.profilePhotoUrl,
    this.frequency = 0,
    this.objective = '',
  }) : super(type: 'person');

  String get fullName => '$firstName $lastName';
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
