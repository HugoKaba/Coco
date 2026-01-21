import 'package:flutter/material.dart';

class InputWrapper extends StatelessWidget {
  final Widget child;
  final Color fieldColor;
  final Color innerShadow;

  const InputWrapper({
    super.key,
    required this.child,
    required this.fieldColor,
    required this.innerShadow,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20);
    final borderColor = Colors.white.withOpacity(0.08);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: innerShadow,
            blurRadius: 15,
            offset: const Offset(0, 0),
            spreadRadius: 0,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}
