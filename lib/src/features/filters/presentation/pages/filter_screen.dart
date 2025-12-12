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

  void _onSearchChanged() {
    ref
        .read(userSearchProvider.notifier)
        .onSearchCityChanged(_searchController.text);
  }

  Future<void> _locate() async {
    try {
      final status = await Geolocator.checkPermission();
      if (status == LocationPermission.denied) {
        final req = await Geolocator.requestPermission();
        if (req == LocationPermission.denied ||
            req == LocationPermission.deniedForever) {
          return;
        }
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      ref
          .read(filterProvider.notifier)
          .setDeviceLocation(pos.latitude, pos.longitude);

      ref
          .read(filterProvider.notifier)
          .setDeviceLocation(pos.latitude, pos.longitude);

      _triggerSearch();
    } catch (e) {
      debugPrint('Location Error: $e');
    }
  }

  void _triggerSearch() {
    final criteria = ref.read(filterProvider);
    ref.read(userSearchProvider.notifier).performSearch(criteria);
  }

  void _selectCity(City city) {
    _searchController.removeListener(_onSearchChanged);
    _searchController.text = city.name;
    _searchController.addListener(_onSearchChanged);

    ref.read(userSearchProvider.notifier).selectCity(city);
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
          final centerLat = criteria.isAroundMe
              ? (criteria.deviceLat ?? 0)
              : (searchState.selectedCity?.lat ?? 0);
          final centerLng = criteria.isAroundMe
              ? (criteria.deviceLng ?? 0)
              : (searchState.selectedCity?.lng ?? 0);
          return SearchResultsScreen(
            results: searchState.filteredUsers,
            centerLat: centerLat,
            centerLng: centerLng,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(filterProvider, (prev, next) {
      ref.read(userSearchProvider.notifier).performSearch(next);
    });

    final searchState = ref.watch(userSearchProvider);
    final criteria = ref.watch(filterProvider);

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
                LocationFilterSection(
                  searchController: _searchController,
                  searchFocus: _searchFocus,
                  onClearSearch: _clearSearch,
                ),
                const Divider(height: 32, thickness: 1),
                const SportsFilterSection(),
                const SizedBox(height: 24),
                const LevelFilterSection(),
                const SizedBox(height: 24),
                const AvailabilitiesFilterSection(),
                const SizedBox(height: 24),
                const AgeFilterSection(),
              ],
            ),
          ),

          // City Suggestions Overlay
          if (!criteria.isAroundMe &&
              searchState.filteredCities.isNotEmpty &&
              searchState.selectedCity == null)
            Positioned(
              top: 140,
              left: 16,
              right: 16,
              height: 200,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: ListView.separated(
                  itemCount: searchState.filteredCities.length,
                  separatorBuilder: (ctx, i) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final city = searchState.filteredCities[i];
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

          if (searchState.isLoading)
            const Center(child: CircularProgressIndicator()),
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
            child: Text(
              "Rechercher",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
