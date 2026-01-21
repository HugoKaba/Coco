import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../gender_option.dart';

class GenderSelectorRow extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onGenderSelected;
  final Color accentColor;

  const GenderSelectorRow({
    super.key,
    required this.selectedGender,
    required this.onGenderSelected,
    required this.accentColor,
  });

  Widget _genderOption(String label) => GenderOption(
    label: label,
    selectedGender: selectedGender,
    onTap: onGenderSelected,
    accentColor: accentColor,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        tr('register.gender_male'),
        tr('register.gender_female'),
        tr('register.gender_nb'),
      ].map(_genderOption).toList(),
    );
  }
}
