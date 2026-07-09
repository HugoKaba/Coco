import 'package:flutter/material.dart';

class ClubCreationStyle {
  static const accent = Color(0xFFCD8232);

  // Couleurs dérivées du thème (clair/sombre).
  static Color background(BuildContext context) =>
      Theme.of(context).colorScheme.surface;
  static Color field(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHighest;
  static Color inputInnerShadow(BuildContext context) =>
      Theme.of(context).colorScheme.outlineVariant;
}
