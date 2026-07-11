import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';

/// Champ de saisie standard de l'app (design system).
///
/// Style aligné sur le thème (couleurs de surface) + tokens (rayon, padding).
/// Fonctionne en clair comme en sombre.
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final TextAlign textAlign;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? fieldColor;
  final Color? borderColor;

  const AppTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
    this.onTap,
    this.fieldColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fill = fieldColor ?? cs.surfaceContainerHighest;
    final border = borderColor ?? cs.outlineVariant;

    OutlineInputBorder outline(double alpha) => OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: border.withValues(alpha: alpha)),
        );

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      textAlign: textAlign,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(color: cs.onSurface),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: cs.onSurfaceVariant),
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        enabledBorder: outline(0.4),
        focusedBorder: outline(0.7),
      ),
    );
  }
}
