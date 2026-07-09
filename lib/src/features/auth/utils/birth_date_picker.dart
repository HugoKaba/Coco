import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Future<DateTime?> pickBirthDate({
  required BuildContext context,
  required Color accentColor,
  required TextEditingController dayController,
  required TextEditingController monthController,
  required TextEditingController yearController,
}) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now().subtract(const Duration(days: 6570)),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    builder: (context, child) {
      // Suit le thème de l'app (clair/sombre), avec l'accent orange.
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(
            context,
          ).colorScheme.copyWith(primary: accentColor),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    if (picked.difference(DateTime.now()).inDays.abs() < 6570) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(tr('register.age_error'))));
      }
      return null;
    }
    dayController.text = DateFormat('dd').format(picked);
    monthController.text = DateFormat('MM').format(picked);
    yearController.text = DateFormat('yyyy').format(picked);
    return picked;
  }
  return null;
}
