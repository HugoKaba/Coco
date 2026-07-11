import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coco/src/features/filters/application/user_search_service.dart';
import 'package:coco/src/features/filters/domain/models/city.dart';
import '../../application/event_filter_provider.dart';
import '../widgets/event_location_filter_section.dart';
import '../widgets/event_sports_filter_section.dart';
import '../widgets/date_filter_section.dart';
import '../widgets/event_filter_city_list.dart';
import '../widgets/event_filter_header.dart';
import '../widgets/event_filter_apply_button.dart';

class EventFilterSheet extends ConsumerStatefulWidget {
  const EventFilterSheet({super.key});

  @override
  ConsumerState<EventFilterSheet> createState() => _EventFilterSheetState();
}

class _EventFilterSheetState extends ConsumerState<EventFilterSheet> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
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

    ref.read(eventFilterProvider.notifier).selectCity(city);
    ref.read(eventFilterProvider.notifier).toggleAroundMe(false);

    _searchFocus.unfocus();
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(userSearchProvider.notifier).clearCity();
    ref.read(eventFilterProvider.notifier).selectCity(null);
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(userSearchProvider);
    final filterState = ref.watch(eventFilterProvider);
    final notifier = ref.read(eventFilterProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          EventFilterHeader(
            onReset: () {
              notifier.reset();
              _clearSearch();
            },
          ),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    children: [
                      EventLocationFilterSection(
                        searchController: _searchController,
                        searchFocus: _searchFocus,
                        onClearSearch: _clearSearch,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                        child: Divider(height: 48, thickness: 1),
                      ),
                      DateFilterSection(
                        selectedDate: filterState.selectedDate,
                        onDateChanged: (d) => notifier.setDate(d),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      const EventSportsFilterSection(),
                    ],
                  ),
                ),
                if (!filterState.isAroundMe &&
                    searchState.filteredCities.isNotEmpty &&
                    _searchFocus.hasFocus)
                  EventFilterCityList(
                    cities: searchState.filteredCities,
                    onSelectCity: _selectCity,
                  ),
              ],
            ),
          ),
          EventFilterApplyButton(onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
