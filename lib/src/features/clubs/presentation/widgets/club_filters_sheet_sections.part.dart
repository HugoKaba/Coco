// ignore_for_file: invalid_use_of_protected_member
part of 'club_filters_sheet.dart';

Widget _buildClubFilterHeader(_ClubFiltersSheetState s) => Padding(
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
        onPressed: () => Navigator.pop(s.context),
      ),
    ],
  ),
);

Widget _buildClubFilterSectionTitle(String title) => Text(
  title,
  style: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
);

Widget _buildClubLocationToggle(_ClubFiltersSheetState s) => Container(
  width: double.infinity,
  decoration: BoxDecoration(
    color: _ClubFiltersSheetState._cardColor,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.white10),
  ),
  child: Row(
    children: [
      Expanded(child: _toggle(s, 'Autour de moi', true)),
      Expanded(child: _toggle(s, 'Ville', false)),
    ],
  ),
);

Widget _toggle(_ClubFiltersSheetState s, String label, bool value) {
  final isSelected = s._isAroundMe == value;
  return GestureDetector(
    onTap: () => s.setState(() => s._isAroundMe = value),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? _ClubFiltersSheetState._accentColor
            : Colors.transparent,
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

Widget _buildClubRadiusSlider(_ClubFiltersSheetState s) => Column(
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Rayon',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        Text(
          '${s._radiusKm.toInt()} km',
          style: const TextStyle(
            color: _ClubFiltersSheetState._accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
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
      child: Slider(
        value: s._radiusKm,
        min: 5,
        max: 100,
        divisions: 19,
        label: '${s._radiusKm.toInt()} km',
        onChanged: (val) => s.setState(() => s._radiusKm = val),
      ),
    ),
  ],
);
