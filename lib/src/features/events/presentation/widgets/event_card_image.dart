import 'package:flutter/material.dart';

class EventCardImage extends StatelessWidget {
  final String? imageUrl;

  const EventCardImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image_rounded,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                },
              )
            : const Center(
                child: Icon(
                  Icons.event_note_rounded,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }
}
