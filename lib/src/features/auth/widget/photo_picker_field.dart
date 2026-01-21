import 'dart:typed_data';
import 'package:flutter/material.dart';

class PhotoPickerField extends StatelessWidget {
  final Uint8List? profilePhotoBytes;
  final VoidCallback onTap;
  final Color fieldColor;
  final Color innerShadow;
  final double borderRadius;

  const PhotoPickerField({
    super.key,
    required this.profilePhotoBytes,
    required this.onTap,
    required this.fieldColor,
    required this.innerShadow,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: innerShadow,
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: profilePhotoBytes != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.memory(profilePhotoBytes!, fit: BoxFit.cover),
        )
            : Center(
          child: Text(
            "Sélectionner une photo",
            style: TextStyle(color: Colors.white54),
          ),
        ),
      ),
    );
  }
}
