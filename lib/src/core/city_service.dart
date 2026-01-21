import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CityData {
  final String nomStandard;
  final String nomSansPronom;
  final List<String> zipCodes;
  final double latitude;
  final double longitude;

  CityData({
    required this.nomStandard,
    required this.nomSansPronom,
    required this.zipCodes,
    required this.latitude,
    required this.longitude,
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    final name = json['ville'] as String;
    final normalized = _removeDiacritics(name.toLowerCase());
    final zipList =
        (json['codes_postaux'] as List<dynamic>?)?.cast<String>() ?? [];

    return CityData(
      nomStandard: name,
      nomSansPronom: normalized,
      zipCodes: zipList,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

String _removeDiacritics(String str) {
  var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûüÿÑñ';
  var withoutDia = 'AAAAAAaaaaaaOOOOOOooooooEEEEeeeeCcIIIIiiiiUUUUuuuuyNn';
  for (int i = 0; i < withDia.length; i++) {
    str = str.replaceAll(withDia[i], withoutDia[i]);
  }
  return str;
}

class CityService {
  static CityService? _instance;
  List<CityData> _cities = [];
  bool _isLoaded = false;

  CityService._();

  static CityService get instance {
    _instance ??= CityService._();
    return _instance!;
  }

  Future<void> loadCities() async {
    if (_isLoaded) return;

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/city/villes_idf.json',
      );
      final dynamic jsonData = json.decode(jsonString);
      final List<dynamic> data = jsonData is List ? jsonData : jsonData['data'];

      _cities = data
          .map((item) => CityData.fromJson(item as Map<String, dynamic>))
          .toList();
      _isLoaded = true;
      debugPrint('Villes chargées: ${_cities.length} communes');
    } catch (e) {
      debugPrint('Erreur lors du chargement des villes: $e');
      _cities = [];
    }
  }

  bool get isLoaded => _isLoaded;

  List<CityData> searchCities(String query) {
    if (query.isEmpty) return [];
    if (!_isLoaded) {
      return [];
    }

    final queryLower = _removeDiacritics(query.toLowerCase().trim());
    final matches = <CityData>[];

    for (final city in _cities) {
      final nomStandardLower = city.nomSansPronom;

      if (nomStandardLower.contains(queryLower) ||
          city.zipCodes.any((z) => z.startsWith(queryLower))) {
        matches.add(city);
      }
    }

    matches.sort((a, b) {
      final aName = a.nomSansPronom;
      final bName = b.nomSansPronom;
      final aStarts = aName.startsWith(queryLower);
      final bStarts = bName.startsWith(queryLower);

      if (aStarts && !bStarts) return -1;
      if (!aStarts && bStarts) return 1;
      return a.nomStandard.compareTo(b.nomStandard);
    });

    return matches.take(50).toList();
  }

  CityData? findCityByName(String cityName) {
    final queryLower = _removeDiacritics(cityName.toLowerCase().trim());
    for (final city in _cities) {
      if (city.nomSansPronom == queryLower ||
          city.nomStandard.toLowerCase() == queryLower) {
        return city;
      }
    }
    return null;
  }
}
