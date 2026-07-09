import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/filter_state_provider.dart';
import '../../application/user_search_service.dart';
import '../widgets/filter_search_button.dart';
import '../widgets/filter_app_bar.dart';
import '../widgets/filter_screen_content.dart';
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
      ).timeout(const Duration(seconds: 8));
      ref
          .read(filterProvider.notifier)
          .setDeviceLocation(pos.latitude, pos.longitude);
      ref
          .read(userSearchProvider.notifier)
          .performSearch(ref.read(filterProvider));
    } catch (e) {
      debugPrint('Location Error: $e');
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
    return Scaffold(
      appBar: const FilterAppBar(),
      body: FilterScreenContent(
        searchController: _searchController,
        searchFocus: _searchFocus,
        onClearSearch: _clearSearch,
        onSelectCity: _selectCity,
      ),
      bottomNavigationBar: FilterSearchButton(
        onPressed: _showResults,
        label: tr('filters.search'),
      ),
    );
  }
}
