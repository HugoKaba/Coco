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
                  color: isSelected
                      ? accentColor
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$val',
                  style: TextStyle(
                    color: isSelected
                        ? Colors.black
                        : Theme.of(context).colorScheme.onSurface,
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
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
