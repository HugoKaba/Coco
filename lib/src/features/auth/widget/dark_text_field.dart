import 'package:flutter/material.dart';
import 'package:coco/src/shared/widgets/app_text_field.dart';

/// Ancien champ auth, conservé pour compatibilité. Il délègue désormais au
/// composant du design system [AppTextField]. À terme, migrer les appels vers
/// [AppTextField] directement puis supprimer ce wrapper.
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
    return AppTextField(
      controller: controller,
      hintText: hintText,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.start,
      readOnly: readOnly,
      onTap: onTap,
      fieldColor: fieldColor,
      borderColor: innerShadow,
    );
  }
}
