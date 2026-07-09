import 'package:flutter/material.dart';

class EventCardImage extends StatelessWidget {
  final String? imageUrl;

  const EventCardImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.broken_image_rounded,
                      size: 40,
                      color: cs.onSurfaceVariant,
                    ),
                  );
                },
              )
            : Center(
                child: Icon(
                  Icons.event_note_rounded,
                  size: 40,
                  color: cs.onSurfaceVariant,
                ),
              ),
      ),
    );
  }
}
