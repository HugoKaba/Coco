import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Alignment alignment;

  const NavigationButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: alignment,
        child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(const Color(0xFFCD8232)),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            elevation: WidgetStateProperty.all(0),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
          ),
          child: Text(text),
        ),
      ),
    );
  }
}
