import '../domain/app_enums.dart';

class ReferenceTables {
  static Map<int, String> get sports => Map.fromEntries(
    BoxSport.values.map((e) => MapEntry(e.id, e.translationKey)),
  );

  static Map<int, String> get levels => Map.fromEntries(
    BoxLevel.values.map((e) => MapEntry(e.id, e.translationKey)),
  );

  static Map<int, String> get days => Map.fromEntries(
    BoxDay.values.map((e) => MapEntry(e.id, e.translationKey)),
  );

  static String getSportName(int id) => BoxSport.fromId(id).translationKey;
  static String getLevelName(int id) => BoxLevel.fromId(id).translationKey;
  static String getDayName(int id) => BoxDay.fromId(id).translationKey;

  static int getSportId(String key) => BoxSport.values
      .firstWhere(
        (e) => e.translationKey == key,
        orElse: () => BoxSport.football,
      )
      .id;
  static int getLevelId(String key) => BoxLevel.values
      .firstWhere(
        (e) => e.translationKey == key,
        orElse: () => BoxLevel.beginner,
      )
      .id;
}
