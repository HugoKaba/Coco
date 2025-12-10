import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'models/location_entity.dart';
import 'services/geolocation_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'search_results_screen.dart';

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

class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({super.key});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  final _service = const GeolocationService();
  List<PersonEntity> _allUsers = [];

  // State
  bool _isAroundMe = true;
  double _radius = 5000.0; // Default 5km
  double? _deviceLat;
  double? _deviceLng;

  // Filters
  final List<String> _selectedSports = [];
  String? _selectedLevel;
  final List<String> _selectedAvailabilities = [];
  RangeValues _ageRange = const RangeValues(18, 60);

  // Constants
  final List<String> _allSports = [
    "Football",
    "Tennis",
    "Padel",
    "Running",
    "Basketball",
  ];
  final List<String> _allLevels = [
    "Débutant",
    "Intermédiaire",
    "Confirmé",
    "Expert",
  ];
  final List<String> _allDays = [
    "Lundi",
    "Mardi",
    "Mercredi",
    "Jeudi",
    "Vendredi",
    "Samedi",
    "Dimanche",
  ];

  // City Data
  List<City> _allCities = [];
  List<City> _filteredCities = [];
  City? _selectedCity;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  List<PersonEntity> _results = [];

  @override
  void initState() {
    super.initState();
    _loadCities();
    _loadUsers();
    _locate();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _loadCities() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/city/villes_idf.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      setState(() {
        _allCities = jsonList.map((e) => City.fromJson(e)).toList();
        // Sort alphabetically
        _allCities.sort((a, b) => a.name.compareTo(b.name));
        debugPrint('Loaded ${_allCities.length} cities');
      });
    } catch (e) {
      debugPrint('Error loading cities: $e');
    }
  }

  Future<void> _loadUsers() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/users/users_idf.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      setState(() {
        _allUsers = jsonList.map((e) {
          return PersonEntity(
            id: e['id'],
            name: e['name'],
            lat: (e['latitude'] as num).toDouble(),
            lng: (e['longitude'] as num).toDouble(),
            metadata: {'city': e['city']},
            sports: (e['sports'] as List?)?.cast<String>() ?? [],
            level: e['level'] ?? '',
            availabilities:
                (e['availabilities'] as List?)?.cast<String>() ?? [],
            age: e['age'] ?? 0,
          );
        }).toList();
      });
      // Initial search if location is already known or just to be ready
      if (_isAroundMe && _deviceLat != null) {
        _performSearch();
      }
    } catch (e) {
      debugPrint('Error loading users: $e');
    }
  }

  void _onSearchChanged() {
    // If the text matches the selected city, we don't want to clear it yet
    // (this happens when we select a city and the text field updates).
    // But if the user types something else, we clear the selection to show suggestions.
    if (_selectedCity != null &&
        _searchController.text != _selectedCity!.name) {
      setState(() => _selectedCity = null);
    }

    if (_searchController.text.isEmpty) {
      setState(() => _filteredCities = []);
      return;
    }

    final query = removeDiacritics(_searchController.text.toLowerCase());
    final matches = _allCities.where((city) {
      final nameMatch = city.normalizedName.contains(query);
      final zipMatch = city.zipCodes.any((zip) => zip.startsWith(query));
      return nameMatch || zipMatch;
    }).toList();

    matches.sort((a, b) {
      final aStartsWith = a.normalizedName.startsWith(query);
      final bStartsWith = b.normalizedName.startsWith(query);

      if (aStartsWith && !bStartsWith) return -1;
      if (!aStartsWith && bStartsWith) return 1;

      return a.name.compareTo(b.name);
    });

    setState(() {
      _filteredCities = matches.take(50).toList();
    });
  }

  Future<void> _locate() async {
    try {
      final status = await Geolocator.checkPermission();
      if (status == LocationPermission.denied) {
        final req = await Geolocator.requestPermission();
        if (req == LocationPermission.denied ||
            req == LocationPermission.deniedForever) {
          debugPrint('Location permission denied');
          return;
        }
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _deviceLat = pos.latitude;
        _deviceLng = pos.longitude;
      });
      if (_isAroundMe) {
        _performSearch();
      }
    } catch (e) {
      debugPrint('Failed to get location: $e');
    }
  }

  void _performSearch() {
    double centerLat;
    double centerLng;

    if (_isAroundMe) {
      if (_deviceLat == null || _deviceLng == null) {
        // Wait for location or show error
        return;
      }
      centerLat = _deviceLat!;
      centerLng = _deviceLng!;
    } else {
      if (_selectedCity == null) {
        setState(() => _results = []);
        return;
      }
      centerLat = _selectedCity!.lat;
      centerLng = _selectedCity!.lng;
    }

    final raw = _allUsers;
    final out = <MapEntry<PersonEntity, double>>[];
    for (final p in raw) {
      final d = _service.distanceMeters(centerLat, centerLng, p.lat, p.lng);

      // Distance Filter
      if (d > _radius) continue;

      // Sport Filter
      if (_selectedSports.isNotEmpty) {
        final hasSport = p.sports.any((s) => _selectedSports.contains(s));
        if (!hasSport) continue;
      }

      // Level Filter
      if (_selectedLevel != null && p.level != _selectedLevel) continue;

      // Availability Filter
      if (_selectedAvailabilities.isNotEmpty) {
        final hasAvail = p.availabilities.any(
          (a) => _selectedAvailabilities.contains(a),
        );
        if (!hasAvail) continue;
      }

      // Age Filter
      if (p.age < _ageRange.start || p.age > _ageRange.end) continue;

      out.add(MapEntry(p, d));
    }
    out.sort((a, b) => a.value.compareTo(b.value));
    setState(() => _results = out.map((e) => e.key).toList());
  }

  void _selectCity(City city) {
    _searchController.removeListener(_onSearchChanged);
    _searchController.text = city.name;
    _searchController.addListener(_onSearchChanged);

    setState(() {
      _selectedCity = city;
      _filteredCities = [];
      _searchFocus.unfocus();
    });
    _performSearch();
  }

  void _showResults() {
    _performSearch();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          results: _results,
          centerLat: _isAroundMe
              ? (_deviceLat ?? 0)
              : (_selectedCity?.lat ?? 0),
          centerLng: _isAroundMe
              ? (_deviceLng ?? 0)
              : (_selectedCity?.lng ?? 0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtres'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Toggle Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isAroundMe = true;
                                _searchController.clear();
                                _selectedCity = null;
                              });
                              _performSearch();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _isAroundMe
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: _isAroundMe
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.1,
                                          ),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: const Center(
                                child: Text(
                                  'Autour de moi',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isAroundMe = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !_isAroundMe
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: !_isAroundMe
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.1,
                                          ),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: const Center(
                                child: Text(
                                  'Choisir une ville',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Search Bar (Only in City Mode)
                if (!_isAroundMe)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      decoration: InputDecoration(
                        hintText: 'Rechercher une ville (ex: Paris, 75001)',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _selectedCity = null;
                                    _results = [];
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                  ),

                // 3. Radius Slider (Always Visible)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Rayon de recherche',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${(_radius / 1000).toStringAsFixed(0)} km',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.deepPurple,
                          inactiveTrackColor: Colors.deepPurple.withValues(
                            alpha: 0.2,
                          ),
                          thumbColor: Colors.deepPurple,
                          overlayColor: Colors.deepPurple.withValues(
                            alpha: 0.1,
                          ),
                        ),
                        child: Slider(
                          min: 1000.0,
                          max: 100000.0, // 100km
                          divisions: 99,
                          value: _radius,
                          onChanged: (v) {
                            setState(() {
                              _radius = (v / 1000).round() * 1000;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 32, thickness: 1),

                // 4. Filters Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sports
                      const Text(
                        "Sports",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _allSports.map((sport) {
                          final isSelected = _selectedSports.contains(sport);
                          return FilterChip(
                            label: Text(sport),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedSports.add(sport);
                                } else {
                                  _selectedSports.remove(sport);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Level
                      const Text(
                        "Niveau",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedLevel,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                        ),
                        hint: const Text("Choisir un niveau"),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text("Tous"),
                          ),
                          ..._allLevels.map(
                            (l) => DropdownMenuItem(value: l, child: Text(l)),
                          ),
                        ],
                        onChanged: (v) => setState(() => _selectedLevel = v),
                      ),
                      const SizedBox(height: 24),

                      // Availability
                      const Text(
                        "Disponibilités",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _allDays.map((day) {
                          final isSelected = _selectedAvailabilities.contains(
                            day,
                          );
                          return FilterChip(
                            label: Text(day),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedAvailabilities.add(day);
                                } else {
                                  _selectedAvailabilities.remove(day);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Age
                      const Text(
                        "Âge",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      RangeSlider(
                        values: _ageRange,
                        min: 18,
                        max: 100,
                        divisions: 82,
                        labels: RangeLabels(
                          "${_ageRange.start.round()}",
                          "${_ageRange.end.round()}",
                        ),
                        onChanged: (v) => setState(() => _ageRange = v),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // City Suggestions Overlay
          if (!_isAroundMe &&
              _filteredCities.isNotEmpty &&
              _selectedCity == null)
            Positioned(
              top: 140, // Adjust based on layout
              left: 16,
              right: 16,
              height: 200,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: ListView.separated(
                  itemCount: _filteredCities.length,
                  separatorBuilder: (ctx, i) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final city = _filteredCities[i];
                    return ListTile(
                      title: Text(
                        city.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(city.zipCodes.join(', ')),
                      onTap: () => _selectCity(city),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _showResults,
            child: const Text(
              "Rechercher",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
