import 'package:flutter/material.dart';

class InputWrapper extends StatelessWidget {
  final Widget child;
  final Color fieldColor;
  final Color innerShadow;
  final double borderRadius;

  const InputWrapper({
    super.key,
    required this.child,
    required this.fieldColor,
    required this.innerShadow,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.white.withValues(alpha: 0.08);
    final radius = BorderRadius.circular(borderRadius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: radius,
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
      child: ClipRRect(borderRadius: radius, child: child),
    );
  }
}
