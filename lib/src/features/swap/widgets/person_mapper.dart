import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../filters/domain/models/person_entity.dart';
import '../models/profile.dart';
import '../../../core/data/reference_tables.dart';

extension PersonEntityMapper on PersonEntity {
  Profile toProfile() {
    return Profile(
      name: '$firstName $lastName',
      username: '@${firstName.toLowerCase()}',
      imageUrl: profilePhotoUrl ?? 'https://placehold.co/400x400.png',
      sports: sports.take(5).map(_mapSport).toList(),
      description: bio ?? tr('swipe.no_description'),
      activityFrequency: '$frequency ${tr('swipe.times_per_week')}',
      availableDays: availabilities
          .map((id) => ReferenceTables.getDayName(id))
          .toSet(),
    );
  }

  ProfileSport _mapSport(UserSport sport) {
    IconData icon = _mapSportIcon(sport.sportId);
    Color color = _mapLevelColor(sport.levelId);

    return ProfileSport(
      icon: icon,
      color: color,
      name: ReferenceTables.getSportName(sport.sportId),
      level: ReferenceTables.getLevelName(sport.levelId),
    );
  }

  IconData _mapSportIcon(int sportId) {
    switch (sportId) {
      case 1:
        return Icons.sports_soccer;
      case 2:
        return Icons.sports_tennis;
      case 3:
        return Icons.directions_run;
      case 4:
        return Icons.sports_basketball;
      case 5:
        return Icons.fitness_center;
      case 6:
        return Icons.fitness_center;
      case 7:
        return Icons.pool;
      case 8:
        return Icons.directions_bike;
      default:
        return Icons.sports;
    }
  }

  Color _mapLevelColor(int levelId) {
    switch (levelId) {
      case 1:
        return const Color(0xFF4CAF50);
      case 2:
        return const Color(0xFF2196F3);
      case 3:
        return const Color(0xFFFF9800);
      case 4:
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }
}
