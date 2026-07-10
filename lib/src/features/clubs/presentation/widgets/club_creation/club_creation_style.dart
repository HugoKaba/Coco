import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_colors.dart';

class ClubCreationStyle {
  static const accent = AppColors.brand;

  // Couleurs dérivées du thème (clair/sombre).
  static Color background(BuildContext context) =>
      Theme.of(context).colorScheme.surface;
  static Color field(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHighest;
  static Color inputInnerShadow(BuildContext context) =>
      Theme.of(context).colorScheme.outlineVariant;
}
