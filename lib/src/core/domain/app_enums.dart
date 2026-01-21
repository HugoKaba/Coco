enum BoxSport {
  football(1, 'sports.football'),
  tennis(2, 'sports.tennis'),
  running(3, 'sports.running'),
  basketball(4, 'sports.basketball'),
  fitness(5, 'sports.fitness'),
  crossfit(6, 'sports.crossfit'),
  swimming(7, 'sports.swimming'),
  cycling(8, 'sports.cycling');

  final int id;
  final String translationKey;
  const BoxSport(this.id, this.translationKey);

  static BoxSport fromId(int id) =>
      values.firstWhere((e) => e.id == id, orElse: () => football);
}

enum BoxLevel {
  beginner(1, 'levels.beginner'),
  intermediate(2, 'levels.intermediate'),
  confirmed(3, 'levels.confirmed'),
  expert(4, 'levels.expert');

  final int id;
  final String translationKey;
  const BoxLevel(this.id, this.translationKey);

  static BoxLevel fromId(int id) =>
      values.firstWhere((e) => e.id == id, orElse: () => beginner);
}

enum BoxDay {
  monday(1, 'days.monday'),
  tuesday(2, 'days.tuesday'),
  wednesday(3, 'days.wednesday'),
  thursday(4, 'days.thursday'),
  friday(5, 'days.friday'),
  saturday(6, 'days.saturday'),
  sunday(7, 'days.sunday');

  final int id;
  final String translationKey;
  const BoxDay(this.id, this.translationKey);

  static BoxDay fromId(int id) =>
      values.firstWhere((e) => e.id == id, orElse: () => monday);
}
