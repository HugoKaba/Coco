import '../domain/models/city.dart';

class CitySearchHelper {
  static String removeDiacritics(String str) {
    const withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    const withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    var result = str;
    for (var i = 0; i < withDia.length; i++) {
      result = result.replaceAll(withDia[i], withoutDia[i]);
    }
    return result;
  }

  static List<City> searchAndSort(List<City> cities, String query) {
    if (query.isEmpty) return [];

    final q = removeDiacritics(query.toLowerCase());
    final matches = cities
        .where(
          (c) =>
              c.normalizedName.contains(q) ||
              c.zipCodes.any((z) => z.startsWith(q)),
        )
        .toList();

    matches.sort(
      (a, b) =>
          a.normalizedName.startsWith(q) && !b.normalizedName.startsWith(q)
          ? -1
          : (b.normalizedName.startsWith(q) && !a.normalizedName.startsWith(q)
                ? 1
                : a.name.compareTo(b.name)),
    );

    return matches.take(50).toList();
  }
}
