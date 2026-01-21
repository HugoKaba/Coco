import 'package:flutter/material.dart';

class FrequencySelector extends StatelessWidget {
  final int frequency;
  final ValueChanged<int> onChanged;
  final Color accentColor;

  const FrequencySelector({
    super.key,
    required this.frequency,
    required this.onChanged,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final val = index + 1;
            final isSelected = val == frequency;
            return GestureDetector(
              onTap: () => onChanged(val),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? accentColor : const Color(0xFF2C2C2C),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$val',
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          '$frequency fois par semaine',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
