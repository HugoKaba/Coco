import '../../../core/data/reference_tables.dart';

class SeederConstants {
  static const List<String> firstNamesM = [
    'Thomas',
    'Lucas',
    'Leo',
    'Gabriel',
    'Arthur',
    'Hugo',
    'Raphael',
    'Louis',
    'Paul',
    'Maxime',
    'Manon',
  ];
  static const List<String> firstNamesF = [
    'Emma',
    'Jade',
    'Louise',
    'Alice',
    'Chloé',
    'Léa',
    'Lina',
    'Mila',
    'Manon',
    'Rose',
  ];
  static const List<String> lastNames = [
    'Martin',
    'Bernard',
    'Thomas',
    'Petit',
    'Robert',
    'Richard',
    'Durand',
    'Dubois',
    'Moreau',
    'Laurent',
  ];

  static List<int> get _stdLevelIds => ReferenceTables.levels.keys.toList();

  static List<Map<String, dynamic>> get sports =>
      ReferenceTables.sports.entries.map((e) {
        return {'id': e.key, 'name': e.value, 'levels': _stdLevelIds};
      }).toList();

  static List<int> get days => ReferenceTables.days.keys.toList();

  static const List<String> descriptions = [
    "Passionné de sport depuis toujours !",
    "À la recherche de partenaires pour s'entraîner",
    "Le sport, c'est ma vie 💪",
    "Objectif : battre mes records",
    "Toujours motivé pour une session !",
    "Coach certifié et sportif accompli",
    "Prêt à relever tous les défis",
    "Le dépassement de soi, c'est ma philosophie",
    "Sport, santé, bien-être 🏃",
    "Team cardio ou musculation ? Les deux !",
  ];
}
