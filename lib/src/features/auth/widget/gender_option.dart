import 'package:flutter/material.dart';

class GenderOption extends StatelessWidget {
  final String label;
  final String selectedGender;
  final ValueChanged<String> onTap;
  final Color accentColor;

  const GenderOption({
    super.key,
    required this.label,
    required this.selectedGender,
    required this.onTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedGender == label;
    return GestureDetector(
      onTap: () => onTap(label),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? accentColor : Colors.white30, width: 2),
            ),
            child: isSelected
                ? Center(
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor,
                ),
              ),
            )
                : null,
          ),
        ],
      ),
    );
  }
}
