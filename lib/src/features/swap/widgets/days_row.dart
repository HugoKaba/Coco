import 'package:flutter/material.dart';

class DaysRow extends StatelessWidget {
  final Set<String> availableDays;

  const DaysRow({super.key, required this.availableDays});

  @override
  Widget build(BuildContext context) {
    final days = [
      ('Lun.', 'Lun'),
      ('Mar.', 'Mar'),
      ('Mer.', 'Mer'),
      ('Jeu.', 'Jeu'),
      ('Ven.', 'Ven'),
      ('Sam.', 'Sam'),
      ('Dim.', 'Dim'),
    ];
    final color = Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) {
        final isActive = availableDays.contains(day.$2);
        return Column(
          children: [
            Text(
              day.$1,
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
