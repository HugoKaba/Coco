import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../models/profile.dart';

class ProfilePhotoSection extends StatelessWidget {
  final Profile profile;

  const ProfilePhotoSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    // Juste la photo centrée. Les boutons ✕/✓ ne font PAS partie de la carte :
    // ils sont rendus en overlay fixe par-dessus la pile (voir SwipeCardStack).
    return Center(
      child: Container(
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