import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CityData {
  final String nomStandard;
  final String nomSansPronom;
  final String codePostal;
  final String codesPostaux;

  CityData({
    required this.nomStandard,
    required this.nomSansPronom,
    required this.codePostal,
    required this.codesPostaux,
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      nomStandard: json['nom_standard'] ?? '',
      nomSansPronom: json['nom_sans_pronom'] ?? '',
      codePostal: json['code_postal'] ?? '',
      codesPostaux: json['codes_postaux'] ?? json['code_postal'] ?? '',
    );
  }
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
        'assets/communes-france-avec-polygon-2025.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> data = jsonData['data'] as List<dynamic>;

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
      debugPrint('Recherche effectuée mais les villes ne sont pas encore chargées');
      return [];
    }

    final queryLower = query.toLowerCase().trim();
    final results = <CityData>[];

    for (final city in _cities) {
      final nomStandardLower = city.nomStandard.toLowerCase();
      final nomSansPronomLower = city.nomSansPronom.toLowerCase();

      if (nomStandardLower.contains(queryLower) ||
          nomSansPronomLower.contains(queryLower)) {
        results.add(city);
        if (results.length >= 10) break; // Limiter à 10 résultats
      }
    }

    // Trier par pertinence (commence par la requête en premier)
    results.sort((a, b) {
      final aStarts = a.nomStandard.toLowerCase().startsWith(queryLower) ||
          a.nomSansPronom.toLowerCase().startsWith(queryLower);
      final bStarts = b.nomStandard.toLowerCase().startsWith(queryLower) ||
          b.nomSansPronom.toLowerCase().startsWith(queryLower);

      if (aStarts && !bStarts) return -1;
      if (!aStarts && bStarts) return 1;
      return a.nomStandard.compareTo(b.nomStandard);
    });

    debugPrint('Recherche "$query": ${results.length} résultats trouvés');
    return results;
  }

  CityData? findCityByName(String cityName) {
    final queryLower = cityName.toLowerCase().trim();
    for (final city in _cities) {
      if (city.nomStandard.toLowerCase() == queryLower ||
          city.nomSansPronom.toLowerCase() == queryLower) {
        return city;
      }
    }
    return null;
  }
}

