import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
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
              color: isSelected
                  ? accentColor
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isSelected
                    ? accentColor
                    : Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              tr(dayShortKey),
              style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                fontSize: AppFontSize.xs,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
