import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/user_search_service.dart';
import '../../domain/models/city.dart';
import '../providers/filter_state_provider.dart';
import '../widgets/age_filter_section.dart';
import '../widgets/availabilities_filter_section.dart';
import '../widgets/city_suggestions_overlay.dart';
import '../widgets/level_filter_section.dart';
import '../widgets/location_filter_section.dart';
import '../widgets/sports_filter_section.dart';

class FilterScreenContent extends ConsumerWidget {
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final VoidCallback onClearSearch;
  final ValueChanged<City> onSelectCity;

  const FilterScreenContent({
    super.key,
    required this.searchController,
    required this.searchFocus,
    required this.onClearSearch,
    required this.onSelectCity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(userSearchProvider);
    final criteria = ref.watch(filterProvider);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocationFilterSection(
                searchController: searchController,
                searchFocus: searchFocus,
                onClearSearch: onClearSearch,
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
            onSelect: onSelectCity,
          ),
        if (searchState.isLoading)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
