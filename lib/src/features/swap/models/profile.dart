import 'package:flutter/material.dart';

class Profile {
  final String name;
  final String username;
  final String imageUrl;
  final List<IconData> sportIcons;
  final String description;
  final String activityFrequency;
  final Set<String> availableDays;

  Profile({
    required this.name,
    required this.username,
    required this.imageUrl,
    required this.sportIcons,
    required this.description,
    required this.activityFrequency,
    required this.availableDays,
  });
}
