// ignore_for_file: invalid_use_of_protected_member
part of 'slot_creation_screen.dart';

Widget _buildSlotLevelSelector(_SlotCreationScreenState s) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'clubs.slot.level'.tr(),
      style: TextStyle(
        color: Theme.of(s.context).colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    const SizedBox(height: 12),
    Wrap(
      spacing: 8,
      runSpacing: 12,
      children: BoxLevel.values.map((level) {
        final isSelected = s._selectedLevel == level;
        return FilterChip(
          label: Text(level.translationKey.tr()),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) s.setState(() => s._selectedLevel = level);
          },
          backgroundColor: Theme.of(s.context).colorScheme.surfaceContainerHighest,
          selectedColor: _SlotCreationScreenState._accentColor,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected
                ? Colors.white
                : Theme.of(s.context).colorScheme.onSurfaceVariant,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected
                  ? _SlotCreationScreenState._accentColor
                  : Theme.of(s.context).dividerColor,
            ),
          ),
        );
      }).toList(),
    ),
  ],
);

Widget _buildSlotAgeRangeSelector(_SlotCreationScreenState s) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'clubs.slot.age_group'.tr(),
          style: TextStyle(
            color: Theme.of(s.context).colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${s._ageRange.start.round()} - ${s._ageRange.end.round()} ans',
          style: const TextStyle(
            color: _SlotCreationScreenState._accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    const SizedBox(height: 12),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(s.context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(s.context).dividerColor),
      ),
      child: RangeSlider(
        values: s._ageRange,
        min: 5,
        max: 90,
        divisions: 85,
        activeColor: _SlotCreationScreenState._accentColor,
        inactiveColor: Theme.of(s.context).colorScheme.surfaceContainerHighest,
        labels: RangeLabels(
          s._ageRange.start.round().toString(),
          s._ageRange.end.round().toString(),
        ),
        onChanged: (values) => s.setState(() => s._ageRange = values),
      ),
    ),
  ],
);
