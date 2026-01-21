import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DaysRow extends StatelessWidget {
  final Set<String> availableDays;

  const DaysRow({super.key, required this.availableDays});

  @override
  Widget build(BuildContext context) {
    final days = [
      ('days.short.monday', 'days.monday'),
      ('days.short.tuesday', 'days.tuesday'),
      ('days.short.wednesday', 'days.wednesday'),
      ('days.short.thursday', 'days.thursday'),
      ('days.short.friday', 'days.friday'),
      ('days.short.saturday', 'days.saturday'),
      ('days.short.sunday', 'days.sunday'),
    ];
    final color = Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) {
        final isActive = availableDays.contains(day.$2);
        return Column(
          children: [
            Text(
              tr(day.$1),
              style: TextStyle(
                fontSize: 14,
                color: color.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? color : Colors.transparent,
                border: Border.all(
                  color: color.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: isActive
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        );
      }).toList(),
    );
  }
}
