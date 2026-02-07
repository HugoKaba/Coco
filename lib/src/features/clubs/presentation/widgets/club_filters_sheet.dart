import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/features/clubs/domain/models/club_filter_criteria.dart';
import 'package:coco/src/core/domain/app_enums.dart';
import 'package:coco/src/features/auth/widget/city_autocomplete.dart';
import 'package:coco/src/core/city_service.dart';

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
    builder: (context) =>
        ClubFiltersSheet(initialFilters: currentFilters, onApply: onApply),
  );
}

class ClubFiltersSheet extends StatefulWidget {
  final ClubFilterCriteria initialFilters;
  final Function(ClubFilterCriteria) onApply;

  const ClubFiltersSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
  });

  @override
  State<ClubFiltersSheet> createState() => _ClubFiltersSheetState();
}

class _ClubFiltersSheetState extends State<ClubFiltersSheet> {
  late ClubFilterCriteria _filters;
  RangeValues _ageRange = const RangeValues(18, 60);
  bool _isAroundMe = true;
  double _radiusKm = 10.0;

  // City search
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  bool _citiesLoaded = false;

  // Theme colors
  static const Color _bgColor = Color(0xFF121212);
  static const Color _cardColor = Color(0xFF1F1F1F);
  static const Color _accentColor = Color(0xFFCD8232);

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
    _isAroundMe = _filters.isAroundMe;
    _radiusKm = _filters.radiusKm;

    if (_filters.cityName != null) {
      _cityController.text = _filters.cityName!;
    }

    if (_filters.minAge != null && _filters.maxAge != null) {
      _ageRange = RangeValues(_filters.minAge!, _filters.maxAge!);
    }

    // Check if cities are already loaded
    if (CityService.instance.isLoaded) {
      _citiesLoaded = true;
    }
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
          _buildHeader(),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Localisation'),
                  const SizedBox(height: 16),
                  _buildLocationToggle(),
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
                  _buildRadiusSlider(),
                  const SizedBox(height: 32),

                  _buildSectionTitle('clubs.filter.levels'.tr()),
                  const SizedBox(height: 16),
                  _buildLevelsSection(),

                  const SizedBox(height: 32),
                  _buildSectionTitle('clubs.filter.age_group'.tr()),
                  const SizedBox(height: 16),
                  _buildAgeSection(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'filters.title'.tr(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLocationToggle() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(child: _buildToggleOption('Autour de moi', true)),
          Expanded(child: _buildToggleOption('Ville', false)),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String label, bool isAroundMeOption) {
    final isSelected = _isAroundMe == isAroundMeOption;
    return GestureDetector(
      onTap: () => setState(() => _isAroundMe = isAroundMeOption),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRadiusSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Rayon',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              '${_radiusKm.toInt()} km',
              style: const TextStyle(
                color: _accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _accentColor,
            inactiveTrackColor: Colors.white10,
            thumbColor: Colors.white,
            overlayColor: _accentColor.withValues(alpha: 0.2),
            valueIndicatorColor: _accentColor,
            valueIndicatorTextStyle: const TextStyle(color: Colors.white),
          ),
          child: Slider(
            value: _radiusKm,
            min: 5,
            max: 100,
            divisions: 19,
            label: '${_radiusKm.toInt()} km',
            onChanged: (val) => setState(() => _radiusKm = val),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelsSection() {
    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: BoxLevel.values.map((level) {
        final isSelected = _filters.selectedLevels.contains(level.name);
        return FilterChip(
          label: Text(level.translationKey.tr()),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              final newLevels = Set<String>.from(_filters.selectedLevels);
              if (selected) {
                newLevels.add(level.name);
              } else {
                newLevels.remove(level.name);
              }
              _filters = _filters.copyWith(selectedLevels: newLevels);
            });
          },
          backgroundColor: _cardColor,
          selectedColor: _accentColor,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: isSelected ? _accentColor : Colors.white10),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAgeSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_ageRange.start.round()} - ${_ageRange.end.round()} ans',
              style: const TextStyle(
                color: _accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _accentColor,
            inactiveTrackColor: Colors.white10,
            thumbColor: Colors.white,
            overlayColor: _accentColor.withValues(alpha: 0.2),
            valueIndicatorColor: _accentColor,
            valueIndicatorTextStyle: const TextStyle(color: Colors.white),
          ),
          child: RangeSlider(
            values: _ageRange,
            min: 5,
            max: 90,
            divisions: 85,
            labels: RangeLabels(
              _ageRange.start.round().toString(),
              _ageRange.end.round().toString(),
            ),
            onChanged: (values) {
              setState(() {
                _ageRange = values;
                _filters = _filters.copyWith(
                  minAge: values.start,
                  maxAge: values.end,
                );
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _filters = const ClubFilterCriteria();
                  _isAroundMe = true;
                  _radiusKm = 10.0;
                  _ageRange = const RangeValues(18, 60);
                  _cityController.clear();
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white24),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text('filters.reset'.tr()),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                var finalFilters = _filters.copyWith(
                  minAge: _ageRange.start,
                  maxAge: _ageRange.end,
                  isAroundMe: _isAroundMe,
                  radiusKm: _radiusKm,
                );

                if (!_isAroundMe && _cityController.text.isNotEmpty) {
                  final city = CityService.instance.findCityByName(
                    _cityController.text,
                  );
                  if (city != null) {
                    finalFilters = finalFilters.copyWith(
                      cityName: city.nomStandard,
                      cityLat: city.latitude,
                      cityLng: city.longitude,
                    );
                  }
                }

                widget.onApply(finalFilters);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'filters.apply'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
