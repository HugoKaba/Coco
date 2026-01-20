class City {
  final String name;
  final String normalizedName;
  final List<String> zipCodes;
  final double lat;
  final double lng;

  City({
    required this.name,
    required this.normalizedName,
    required this.zipCodes,
    required this.lat,
    required this.lng,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    final name = json['ville'] as String;
    return City(
      name: name,
      normalizedName: removeDiacritics(name.toLowerCase()),
      zipCodes: (json['codes_postaux'] as List).cast<String>(),
      lat: (json['latitude'] as num).toDouble(),
      lng: (json['longitude'] as num).toDouble(),
    );
  }
}

String removeDiacritics(String str) {
  var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûüÿÑñ';
  var withoutDia = 'AAAAAAaaaaaaOOOOOOooooooEEEEeeeeCcIIIIiiiiUUUUuuuuyNn';
  for (int i = 0; i < withDia.length; i++) {
    str = str.replaceAll(withDia[i], withoutDia[i]);
  }
  return str;
}
