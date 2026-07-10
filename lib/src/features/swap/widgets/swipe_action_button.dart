import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_colors.dart';

/// Bouton d'action de swipe (✕ / ✓).
///
/// Volontairement séparé de la carte : dans le design, ces boutons "flottent"
/// à une position fixe et agissent sur la carte du dessus. Ils ne doivent donc
/// PAS faire partie de la carte (sinon ils partent avec elle au swipe et on
/// voit les boutons de la carte suivante en dessous).
class SwipeActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const SwipeActionButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: AppColors.brand,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }
}
