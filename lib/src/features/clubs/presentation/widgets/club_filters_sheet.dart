import 'package:coco/src/core/city_service.dart';
import 'package:coco/src/core/domain/app_enums.dart';
import 'package:coco/src/features/auth/widget/city_autocomplete.dart';
import 'package:coco/src/features/clubs/domain/models/club_filter_criteria.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

part 'club_filters_sheet_sections.part.dart';
part 'club_filters_sheet_filters.part.dart';
part 'club_filters_sheet_actions.part.dart';

void showClubFiltersSheet(
  BuildContext context,
  ClubFilterCriteria currentFilters,
  Function(ClubFilterCriteria) onApply,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>
        ClubFiltersSheet(initialFilters: currentFilters, onApply: onApply),
  );
}

class ClubFiltersSheet extends StatefulWidget {
  const ClubFiltersSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
  });
  final ClubFilterCriteria initialFilters;
  final Function(ClubFilterCriteria) onApply;

  @override
  State<ClubFiltersSheet> createState() => _ClubFiltersSheetState();
}

class _ClubFiltersSheetState extends State<ClubFiltersSheet> {
  late ClubFilterCriteria _filters;
  RangeValues _ageRange = const RangeValues(18, 60);
  bool _isAroundMe = true;
  double _radiusKm = 10;
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  bool _citiesLoaded = false;

  static const Color _bgColor = Color(0xFF121212);
  static const Color _cardColor = Color(0xFF1F1F1F);
  static const Color _accentColor = Color(0xFFCD8232);

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
    _isAroundMe = _filters.isAroundMe;
    _radiusKm = _filters.radiusKm;
    if (_filters.cityName != null) _cityController.text = _filters.cityName!;
    if (_filters.minAge != null && _filters.maxAge != null) {
      _ageRange = RangeValues(_filters.minAge!, _filters.maxAge!);
    }
    _citiesLoaded = CityService.instance.isLoaded;
  }

  @override
  void dispose() {
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildClubFilterHeader(this),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildClubFilterSectionTitle('Localisation'),
                  const SizedBox(height: 16),
                  _buildClubLocationToggle(this),
                  const SizedBox(height: 16),
                  if (!_isAroundMe)
                    SizedBox(
                      height: 60,
                      child: CityAutocomplete(
                        cityController: _cityController,
                        zipController: _zipController,
                        citiesLoaded: _citiesLoaded,
                        setCitiesLoaded: (loaded) =>
                            setState(() => _citiesLoaded = loaded),
                        fieldColor: _cardColor,
                        innerShadow: Colors.transparent,
                      ),
                    ),
                  const SizedBox(height: 16),
                  _buildClubRadiusSlider(this),
                  const SizedBox(height: 32),
                  _buildClubFilterSectionTitle('clubs.filter.levels'.tr()),
                  const SizedBox(height: 16),
                  _buildClubLevelsSection(this),
                  const SizedBox(height: 32),
                  _buildClubFilterSectionTitle('clubs.filter.age_group'.tr()),
                  const SizedBox(height: 16),
                  _buildClubAgeSection(this),
                ],
              ),
            ),
          ),
          _buildClubFilterBottomBar(this),
        ],
      ),
    );
  }
}
