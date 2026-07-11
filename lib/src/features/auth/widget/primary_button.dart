import 'package:flutter/material.dart';
import 'package:coco/src/shared/widgets/app_button.dart';

/// Ancien bouton auth, conservé pour compatibilité. Il délègue désormais au
/// composant du design system [AppButton]. À terme, migrer les appels vers
/// [AppButton] directement puis supprimer ce wrapper.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color accentColor;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      color: accentColor,
    );
  }
}
