import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../features/filters/application/seeder_constants.dart';
import '../../../../core/data/reference_tables.dart';

class DaysSelector extends StatelessWidget {
  final List<int> selectedDays;
  final ValueChanged<List<int>> onChanged;
  final Color accentColor;

  const DaysSelector({
    super.key,
    required this.selectedDays,
    required this.onChanged,
    required this.accentColor,
  });

  void _toggleDay(int dayId) {
    final List<int> newSelection = List.from(selectedDays);
    if (newSelection.contains(dayId)) {
      newSelection.remove(dayId);
    } else {
      newSelection.add(dayId);
    }
    onChanged(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: SeederConstants.days.map((dayId) {
        final dayKey = ReferenceTables.getDayName(dayId);
        final dayShortKey = dayKey.replaceFirst('days.', 'days.short.');
        final isSelected = selectedDays.contains(dayId);

        return GestureDetector(
          onTap: () => _toggleDay(dayId),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? accentColor : const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? accentColor : Colors.white10,
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              tr(dayShortKey),
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
