import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../dark_text_field.dart';

class ProfileBirthDateRow extends StatelessWidget {
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final VoidCallback onTap;
  final Color fieldColor;
  final Color innerShadow;

  const ProfileBirthDateRow({
    super.key,
    required this.dayController,
    required this.monthController,
    required this.yearController,
    required this.onTap,
    required this.fieldColor,
    required this.innerShadow,
  });

  Widget _dateField(TextEditingController controller, String hint) => Expanded(
    child: DarkTextField(
      controller: controller,
      hintText: hint,
      keyboardType: TextInputType.number,
      readOnly: true,
      onTap: onTap,
      fieldColor: fieldColor,
      innerShadow: innerShadow,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _dateField(dayController, tr('register.birth_date_day')),
        const SizedBox(width: 12),
        _dateField(monthController, tr('register.birth_date_month')),
        const SizedBox(width: 12),
        _dateField(yearController, tr('register.birth_date_year')),
      ],
    );
  }
}
