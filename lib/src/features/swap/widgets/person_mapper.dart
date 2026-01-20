import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../filters/domain/models/person_entity.dart';
import '../models/profile.dart';

extension PersonEntityMapper on PersonEntity {
  Profile toProfile() {
    return Profile(
      name: '$prenom $nom',
      username: '@${prenom.toLowerCase()}',
      imageUrl: profilePhotoUrl ?? 'https://placehold.co/400x400.png',
      sports: sports.take(5).map(_mapSport).toList(),
      description: description ?? tr('swipe.no_description'),
      activityFrequency: '$frequency ${tr('swipe.times_per_week')}',
      availableDays: availabilities.map(_normalizeDay).toSet(),
    );
  }

  ProfileSport _mapSport(UserSport sport) {
    IconData icon;
    switch (sport.sportName.toLowerCase()) {
      case 'football':
        icon = Icons.sports_soccer;
        break;
      case 'tennis':
        icon = Icons.sports_tennis;
        break;
      case 'basketball':
        icon = Icons.sports_basketball;
        break;
      case 'running':
        icon = Icons.directions_run;
        break;
      case 'crossfit':
      case 'fitness':
      case 'musculation':
        icon = Icons.fitness_center;
        break;
      case 'natation':
        icon = Icons.pool;
        break;
      case 'cyclisme':
      case 'velo':
        icon = Icons.directions_bike;
        break;
      default:
        icon = Icons.sports;
    }

    Color color;
    switch (sport.level.toLowerCase()) {
      case 'débutant':
      case 'debutant':
        color = Colors.green;
        break;
      case 'intermédiaire':
      case 'intermediaire':
        color = Colors.blue;
        break;
      case 'confirmé':
      case 'confirme':
        color = Colors.orange;
        break;
      case 'expert':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return ProfileSport(
      icon: icon,
      color: color,
      name: sport.sportName,
      level: sport.level,
    );
  }

  String _normalizeDay(String day) {
    switch (day.toLowerCase()) {
      case 'lundi':
        return 'Lun';
      case 'mardi':
        return 'Mar';
      case 'mercredi':
        return 'Mer';
      case 'jeudi':
        return 'Jeu';
      case 'vendredi':
        return 'Ven';
      case 'samedi':
        return 'Sam';
      case 'dimanche':
        return 'Dim';
      default:
        return day;
    }
  }
}
