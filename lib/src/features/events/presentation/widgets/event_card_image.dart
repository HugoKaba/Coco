import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:coco/src/core/theme/app_radius.dart';

class EventCardImage extends StatelessWidget {
  final String? imageUrl;

  const EventCardImage({super.key, required this.imageUrl});

  static const _topRadius = BorderRadius.vertical(
    top: Radius.circular(AppRadius.xxl),
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _topRadius,
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _placeholder(),
              )
            : _placeholder(),
      ),
    );
  }

  /// Placeholder "bold" : dégradé de marque + icône blanche, plutôt qu'un carré
  /// gris qui fait "pas fini".
  Widget _placeholder() {
    return const DecoratedBox(
      decoration: BoxDecoration(gradient: AppColors.brandGradient),
      child: Center(
        child: Icon(
          Icons.sports_rounded,
          size: 44,
          color: Colors.white,
        ),
      ),
    );
  }
}
