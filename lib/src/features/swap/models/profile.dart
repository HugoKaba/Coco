import 'package:flutter/material.dart';

class ProfileSport {
  final IconData icon;
  final Color color;
  final String name;
  final String level;

  ProfileSport({
    required this.icon,
    required this.color,
    required this.name,
    required this.level,
  });
}

class Profile {
  final String name;
  final String username;
  final String imageUrl;
  final List<ProfileSport> sports;
  final String description;
  final String activityFrequency;
  final Set<String> availableDays;

  Profile({
    required this.name,
    required this.username,
    required this.imageUrl,
    required this.sports,
    required this.description,
    required this.activityFrequency,
    required this.availableDays,
  });
}
