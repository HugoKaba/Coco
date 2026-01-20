import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/filter_state_provider.dart';
import '../../application/user_search_service.dart';
import '../widgets/location_filter_section.dart';
import '../widgets/sports_filter_section.dart';
import '../widgets/level_filter_section.dart';
import '../widgets/availabilities_filter_section.dart';
import '../widgets/age_filter_section.dart';
import '../widgets/city_suggestions_overlay.dart';
import '../widgets/filter_search_button.dart';
import '../widgets/filter_app_bar.dart';
import 'search_results_screen.dart';
import '../../domain/models/city.dart';

class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({super.key});
  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _locate();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged() => ref
      .read(userSearchProvider.notifier)
      .onSearchCityChanged(_searchController.text);

  Future<void> _locate() async {
    try {
      final status = await Geolocator.checkPermission();
      if (status == LocationPermission.denied) {
        final req = await Geolocator.requestPermission();
        if (req == LocationPermission.denied ||
            req == LocationPermission.deniedForever) {
          return;
        }
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      ref
          .read(filterProvider.notifier)
          .setDeviceLocation(pos.latitude, pos.longitude);
      ref
          .read(userSearchProvider.notifier)
          .performSearch(ref.read(filterProvider));
    } catch (e) {
      debugPrint('Location Error: \$e');
    }
  }

  void _selectCity(City city) {
    _searchController.removeListener(_onSearchChanged);
    _searchController.text = city.name;
    _searchController.addListener(_onSearchChanged);
    ref.read(userSearchProvider.notifier).selectCity(city);
    ref.read(filterProvider.notifier).toggleAroundMe(false);
    _searchFocus.unfocus();
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(userSearchProvider.notifier).clearCity();
  }

  void _showResults() {
    final criteria = ref.read(filterProvider);
    ref.read(userSearchProvider.notifier).performSearch(criteria);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final searchState = ref.read(userSearchProvider);
          return SearchResultsScreen(
            results: searchState.filteredUsers,
            centerLat: criteria.isAroundMe
                ? (criteria.deviceLat ?? 0)
                : (searchState.selectedCity?.lat ?? 0),
            centerLng: criteria.isAroundMe
                ? (criteria.deviceLng ?? 0)
                : (searchState.selectedCity?.lng ?? 0),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(userSearchProvider);
    final criteria = ref.watch(filterProvider);
    return Scaffold(
      appBar: const FilterAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocationFilterSection(
                  searchController: _searchController,
                  searchFocus: _searchFocus,
                  onClearSearch: _clearSearch,
                ),
                const Divider(height: 32, thickness: 1),
                const SportsFilterSection(),
                const SizedBox(height: 16),
                const LevelFilterSection(),
                const SizedBox(height: 16),
                const AvailabilitiesFilterSection(),
                const SizedBox(height: 16),
                const AgeFilterSection(),
              ],
            ),
          ),
          if (!criteria.isAroundMe &&
              searchState.filteredCities.isNotEmpty &&
              searchState.selectedCity == null)
            CitySuggestionsOverlay(
              cities: searchState.filteredCities,
              onSelect: _selectCity,
            ),
          if (searchState.isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
      bottomNavigationBar: FilterSearchButton(
        onPressed: _showResults,
        label: 'Rechercher',
      ),
    );
  }
}
