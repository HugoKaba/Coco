import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../models/profile.dart';

class ProfilePhotoSection extends StatelessWidget {
  final Profile profile;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  const ProfilePhotoSection({
    super.key,
    required this.profile,
    required this.onLeft,
    required this.onRight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SwipeButton(icon: Icons.close, onTap: onLeft),
        const SizedBox(width: 24),
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(profile.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 24),
        _SwipeButton(icon: Icons.check, onTap: onRight),
      ],
    );
  }
}

class InfoSection extends StatelessWidget {
  final String title;
  final String content;

  const InfoSection({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: LiquidGlass.withOwnLayer(
            settings: const LiquidGlassSettings(thickness: 20, blur: 30),
            shape: LiquidRoundedSuperellipse(borderRadius: 16),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SwipeButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SwipeButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Color(0xFFD4913D),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }
}
