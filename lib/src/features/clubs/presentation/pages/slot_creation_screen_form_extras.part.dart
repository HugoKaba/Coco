// ignore_for_file: invalid_use_of_protected_member
part of 'slot_creation_screen.dart';

Widget _buildSlotLevelSelector(_SlotCreationScreenState s) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'clubs.slot.level'.tr(),
      style: const TextStyle(
        color: Colors.white,
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
          backgroundColor: _SlotCreationScreenState._cardColor,
          selectedColor: _SlotCreationScreenState._accentColor,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected
                  ? _SlotCreationScreenState._accentColor
                  : Colors.white10,
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
          style: const TextStyle(
            color: Colors.white,
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
        color: _SlotCreationScreenState._cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: RangeSlider(
        values: s._ageRange,
        min: 5,
        max: 90,
        divisions: 85,
        activeColor: _SlotCreationScreenState._accentColor,
        inactiveColor: Colors.white10,
        labels: RangeLabels(
          s._ageRange.start.round().toString(),
          s._ageRange.end.round().toString(),
        ),
        onChanged: (values) => s.setState(() => s._ageRange = values),
      ),
    ),
  ],
);
