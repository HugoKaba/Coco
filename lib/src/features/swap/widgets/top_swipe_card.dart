import 'package:flutter/material.dart';

import '../models/profile.dart';
import 'profile_card.dart';

class TopSwipeCard extends StatelessWidget {
  final Profile profile;
  final double dragDx;
  final void Function(DragUpdateDetails)? onPanUpdate;
  final void Function(DragEndDetails)? onPanEnd;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const TopSwipeCard({
    super.key,
    required this.profile,
    required this.dragDx,
    this.onPanUpdate,
    this.onPanEnd,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final normalized = (dragDx / (size.width * 0.5)).clamp(-1.0, 1.0);
    final absNormalized = normalized.abs();

    const maxAngle = 0.4;
    final angle = normalized * maxAngle;

    final offsetX = dragDx * 1.2;
    final offsetY = absNormalized * 80;

    const fadeStart = 0.6;
    final fadeProgress = ((absNormalized - fadeStart) / (1.0 - fadeStart)).clamp(0.0, 1.0);
    final opacity = 1.0 - fadeProgress;

    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: Opacity(
        opacity: opacity,
        child: Transform.translate(
          offset: Offset(offsetX, offsetY),
          child: Transform.rotate(
            alignment: Alignment.bottomCenter,
            angle: angle,
            child: ProfileCard(
              profile: profile,
              onSwipeLeft: onSwipeLeft,
              onSwipeRight: onSwipeRight,
            ),
          ),
        ),
      ),
    );
  }
}
