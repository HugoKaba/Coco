// ignore_for_file: invalid_use_of_protected_member
part of 'club_filters_sheet.dart';

Widget _buildClubFilterHeader(_ClubFiltersSheetState s) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.sm),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'filters.title'.tr(),
        style: TextStyle(
          fontSize: AppFontSize.xl,
          fontWeight: FontWeight.bold,
          color: Theme.of(s.context).colorScheme.onSurface,
        ),
      ),
      IconButton(
        icon: Icon(
          Icons.close,
          color: Theme.of(s.context).colorScheme.onSurface,
        ),
        onPressed: () => Navigator.pop(s.context),
      ),
    ],
  ),
);

Widget _buildClubFilterSectionTitle(BuildContext context, String title) => Text(
  title,
  style: TextStyle(
    fontSize: AppFontSize.md,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface,
  ),
);

Widget _buildClubLocationToggle(_ClubFiltersSheetState s) => Container(
  width: double.infinity,
  decoration: BoxDecoration(
    color: Theme.of(s.context).colorScheme.surfaceContainer,
    borderRadius: BorderRadius.circular(AppRadius.md),
    border: Border.all(color: Theme.of(s.context).dividerColor),
  ),
  child: Row(
    children: [
      Expanded(child: _toggle(s, 'clubs.filter.around_me'.tr(), true)),
      Expanded(child: _toggle(s, 'clubs.filter.city'.tr(), false)),
    ],
  ),
);

Widget _toggle(_ClubFiltersSheetState s, String label, bool value) {
  final isSelected = s._isAroundMe == value;
  return GestureDetector(
    onTap: () => s.setState(() => s._isAroundMe = value),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
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
          color: isSelected
              ? Colors.white
              : Theme.of(s.context).colorScheme.onSurfaceVariant,
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
        Text(
          'clubs.filter.radius'.tr(),
          style: TextStyle(
            color: Theme.of(s.context).colorScheme.onSurfaceVariant,
            fontSize: AppFontSize.sm,
          ),
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
        inactiveTrackColor: Theme.of(s.context).colorScheme.surfaceContainerHighest,
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
