import 'package:flutter/material.dart';

class DarkTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final TextAlign? textAlign;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? fieldColor;
  final Color? innerShadow;

  const DarkTextField({
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
    this.innerShadow,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fill = fieldColor ?? cs.surfaceContainerHighest;
    final border = innerShadow ?? cs.outlineVariant;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.start,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(color: cs.onSurface),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: cs.onSurfaceVariant),
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border.withValues(alpha: 0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border.withValues(alpha: 0.7)),
        ),
      ),
    );
  }
}
