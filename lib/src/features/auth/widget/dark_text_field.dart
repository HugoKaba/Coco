import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'input_wrapper.dart';

class DarkTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Color fieldColor;
  final Color innerShadow;

  const DarkTextField({
    super.key,
    required this.controller,
    this.hintText = "",
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    required this.fieldColor,
    required this.innerShadow,
  });

  @override
  Widget build(BuildContext context) {
    return InputWrapper(
      fieldColor: fieldColor,
      innerShadow: innerShadow,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),
        validator: (v) {
          if (keyboardType == TextInputType.emailAddress) {
            return (v == null || v.isEmpty) ? tr('sign_in.enter_email') : null;
          }
          if (obscureText) {
            return (v == null || v.length < 6) ? tr('sign_in.password_length') : null;
          }
          return null;
        },
      ),
    );
  }
}
