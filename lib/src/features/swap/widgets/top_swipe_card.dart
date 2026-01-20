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
    final centerOffset = MediaQuery.of(context).size.width / 2;
    final normalizedDrag = (dragDx / centerOffset).clamp(-1.0, 1.0);
    const maxAngle = 0.6;

    final angle = normalizedDrag * maxAngle;
    final offsetX = dragDx;
    final offsetY = normalizedDrag.abs() * 50;

    final fadeProgress = (normalizedDrag.abs() - 0.2) / 0.8;
    final overlayOpacity = fadeProgress.clamp(0.0, 1.0) * 0.8;

    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: Opacity(
        opacity: 1.0 - overlayOpacity,
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
