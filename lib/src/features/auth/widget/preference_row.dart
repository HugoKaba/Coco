import 'package:flutter/material.dart';
import 'preference_option.dart';

class PreferenceRow extends StatelessWidget {
  final String selectedPreference;
  final ValueChanged<String> onTap;
  final Color accentColor;

  const PreferenceRow({
    super.key,
    required this.selectedPreference,
    required this.onTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final options = ["Aucune", "L", "M", "M+"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: options
          .map((opt) => PreferenceOption(label: opt, isSelected: selectedPreference == opt, onTap: onTap, accentColor: accentColor))
          .toList(),
    );
  }
}
