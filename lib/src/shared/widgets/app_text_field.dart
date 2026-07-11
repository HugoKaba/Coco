import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';

/// Thème GLOBAL des champs (filled + tokens). Branché dans `ThemeData` (voir
/// main.dart) pour que TOUT champ de l'app — `TextField`,
/// `DropdownButtonFormField`, `InputDecorator`… — ait le même rendu sans avoir
/// à répéter la décoration. C'est la source unique du style de champ.
InputDecorationTheme appInputDecorationTheme(ColorScheme cs) {
  OutlineInputBorder side(double alpha) => OutlineInputBorder(
        borderRadius: AppRadius.lgAll,
        borderSide: BorderSide(color: cs.outlineVariant.withValues(alpha: alpha)),
      );

  return InputDecorationTheme(
    filled: true,
    fillColor: cs.surfaceContainerHighest,
    alignLabelWithHint: true,
    hintStyle: TextStyle(color: cs.onSurfaceVariant),
    labelStyle: TextStyle(color: cs.onSurfaceVariant),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.md,
    ),
    border: side(0.4),
    enabledBorder: side(0.4),
    focusedBorder: side(0.7),
  );
}

/// Décoration de champ ponctuelle. Ne définit que ce qui est spécifique (hint,
/// label, et surcharges de couleur) ; tout le reste (filled, padding, bordures)
/// vient du [appInputDecorationTheme] global.
InputDecoration appInputDecoration(
  BuildContext context, {
  String? hint,
  String? label,
  Color? fill,
  Color? border,
}) {
  OutlineInputBorder? side(double alpha) => border == null
      ? null
      : OutlineInputBorder(
          borderRadius: AppRadius.lgAll,
          borderSide: BorderSide(color: border.withValues(alpha: alpha)),
        );

  return InputDecoration(
    hintText: hint,
    labelText: label,
    // `null` => on retombe sur les valeurs du thème global.
    fillColor: fill,
    enabledBorder: side(0.4),
    focusedBorder: side(0.7),
  );
}

/// Champ de saisie standard de l'app (design system).
///
/// Basé sur [TextFormField] : accepte un [validator] et s'intègre à un [Form].
/// Le style vient du thème global des champs ([appInputDecorationTheme]).
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final TextAlign textAlign;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? fieldColor;
  final Color? borderColor;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
    this.onTap,
    this.fieldColor,
    this.borderColor,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      textAlign: textAlign,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      style: TextStyle(color: cs.onSurface),
      decoration: appInputDecoration(
        context,
        hint: hintText,
        label: labelText,
        fill: fieldColor,
        border: borderColor,
      ),
    );
  }
}
