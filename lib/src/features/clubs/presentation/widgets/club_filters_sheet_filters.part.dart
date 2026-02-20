// ignore_for_file: invalid_use_of_protected_member
part of 'club_filters_sheet.dart';

Widget _buildClubLevelsSection(_ClubFiltersSheetState s) => Wrap(
  spacing: 8,
  runSpacing: 12,
  children: BoxLevel.values.map((level) {
    final isSelected = s._filters.selectedLevels.contains(level.name);
    return FilterChip(
      label: Text(level.translationKey.tr()),
      selected: isSelected,
      onSelected: (selected) {
        s.setState(() {
          final levels = Set<String>.from(s._filters.selectedLevels);
          selected ? levels.add(level.name) : levels.remove(level.name);
          s._filters = s._filters.copyWith(selectedLevels: levels);
        });
      },
      backgroundColor: _ClubFiltersSheetState._cardColor,
      selectedColor: _ClubFiltersSheetState._accentColor,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.white70,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? _ClubFiltersSheetState._accentColor
              : Colors.white10,
        ),
      ),
    );
  }).toList(),
);

Widget _buildClubAgeSection(_ClubFiltersSheetState s) => Column(
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${s._ageRange.start.round()} - ${s._ageRange.end.round()} ans',
          style: const TextStyle(
            color: _ClubFiltersSheetState._accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    ),
    const SizedBox(height: 8),
    SliderTheme(
      data: SliderTheme.of(s.context).copyWith(
        activeTrackColor: _ClubFiltersSheetState._accentColor,
        inactiveTrackColor: Colors.white10,
        thumbColor: Colors.white,
        overlayColor: _ClubFiltersSheetState._accentColor.withValues(
          alpha: 0.2,
        ),
        valueIndicatorColor: _ClubFiltersSheetState._accentColor,
        valueIndicatorTextStyle: const TextStyle(color: Colors.white),
      ),
      child: RangeSlider(
        values: s._ageRange,
        min: 5,
        max: 90,
        divisions: 85,
        labels: RangeLabels(
          s._ageRange.start.round().toString(),
          s._ageRange.end.round().toString(),
        ),
        onChanged: (values) => s.setState(() {
          s._ageRange = values;
          s._filters = s._filters.copyWith(
            minAge: values.start,
            maxAge: values.end,
          );
        }),
      ),
    ),
  ],
);
