import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../filters/presentation/providers/filter_state_provider.dart';
import '../../filters/application/user_search_service.dart';
import '../../filters/presentation/widgets/location_filter_section.dart';
import '../../filters/presentation/widgets/sports_filter_section.dart';
import '../../filters/presentation/widgets/level_filter_section.dart';
import '../../filters/presentation/widgets/availabilities_filter_section.dart';
import '../../filters/presentation/widgets/age_filter_section.dart';
import '../../filters/domain/models/city.dart';
import 'swipe_filter_header.dart';
import 'swipe_filter_apply_button.dart';
import 'swipe_filter_city_list.dart';

class SwipeFilterSheet extends ConsumerStatefulWidget {
  const SwipeFilterSheet({super.key});

  @override
  ConsumerState<SwipeFilterSheet> createState() => _SwipeFilterSheetState();
}

class _SwipeFilterSheetState extends ConsumerState<SwipeFilterSheet> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final selectedCity = ref.read(userSearchProvider).selectedCity;
    if (selectedCity != null) {
      _searchController.text = selectedCity.name;
    }
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

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(userSearchProvider);
    final criteria = ref.watch(filterProvider);
    const kOrangeColor = AppColors.brand;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SwipeFilterHeader(),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      LocationFilterSection(
                        searchController: _searchController,
                        searchFocus: _searchFocus,
                        onClearSearch: _clearSearch,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Divider(height: 48, thickness: 1),
                      ),
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
                if (!criteria.isAroundMe &&
                    searchState.filteredCities.isNotEmpty &&
                    _searchFocus.hasFocus)
                  SwipeFilterCityList(
                    searchState: searchState,
                    onSelectCity: _selectCity,
                  ),
              ],
            ),
          ),
          SwipeFilterApplyButton(
            onPressed: () {
              ref
                  .read(userSearchProvider.notifier)
                  .performSearch(ref.read(filterProvider));
              Navigator.pop(context);
            },
            backgroundColor: kOrangeColor,
          ),
        ],
      ),
    );
  }
}
