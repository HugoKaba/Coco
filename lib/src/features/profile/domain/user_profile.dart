import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final DateTime? birthDate;
  final String city;
  final String bio;
  final String profilePhoto;
  final int trainingFrequency;
  final String sportsGoal;
  final List<int> days; // 0=Monday, etc.
  final List<UserSport> userSports;

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    this.birthDate,
    required this.city,
    required this.bio,
    required this.profilePhoto,
    required this.trainingFrequency,
    required this.sportsGoal,
    required this.days,
    required this.userSports,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return UserProfile(
      id: doc.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      age: data['age'] ?? 18,
      gender: data['gender'] ?? 'M',
      birthDate: (data['birthDate'] as Timestamp?)?.toDate(),
      city: data['city'] ?? '',
      bio: data['bio'] ?? '',
      profilePhoto: data['profilePhoto'] ?? '',
      trainingFrequency: data['trainingFrequency'] ?? 0,
      sportsGoal: data['sportsGoal'] ?? '',
      days:
          (data['days'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
      userSports:
          (data['userSports'] as List<dynamic>?)
              ?.map((e) => UserSport.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'gender': gender,
      'birthDate': birthDate != null ? Timestamp.fromDate(birthDate!) : null,
      'city': city,
      'bio': bio,
      'profilePhoto': profilePhoto,
      'trainingFrequency': trainingFrequency,
      'sportsGoal': sportsGoal,
      'days': days,
      'userSports': userSports.map((e) => e.toMap()).toList(),
    };
  }

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    int? age,
    String? gender,
    DateTime? birthDate,
    String? city,
    String? bio,
    String? profilePhoto,
    int? trainingFrequency,
    String? sportsGoal,
    List<int>? days,
    List<UserSport>? userSports,
  }) {
    return UserProfile(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      city: city ?? this.city,
      bio: bio ?? this.bio,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      trainingFrequency: trainingFrequency ?? this.trainingFrequency,
      sportsGoal: sportsGoal ?? this.sportsGoal,
      days: days ?? this.days,
      userSports: userSports ?? this.userSports,
    );
  }
}

class UserSport {
  final String sportId;
  final int levelId;

  const UserSport({required this.sportId, required this.levelId});

  factory UserSport.fromMap(Map<String, dynamic> map) {
    return UserSport(
      sportId: map['sportId'] ?? '',
      levelId: map['levelId'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'sportId': sportId, 'levelId': levelId};
  }
}
