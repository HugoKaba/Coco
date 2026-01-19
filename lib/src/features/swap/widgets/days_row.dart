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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) {
        final isActive = availableDays.contains(day.$2);
        return Column(
          children: [
            Text(
              day.$1,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black87, width: 2),
                color: isActive ? Colors.black87 : Colors.transparent,
              ),
              child: isActive
                  ? const Icon(Icons.circle, color: Colors.black87, size: 16)
                  : null,
            ),
          ],
        );
      }).toList(),
    );
  }
}
