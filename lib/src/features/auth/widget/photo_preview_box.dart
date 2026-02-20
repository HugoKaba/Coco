import 'dart:typed_data';
import 'package:flutter/material.dart';

class PhotoPreviewBox extends StatelessWidget {
  final Uint8List? profilePhotoBytes;

  const PhotoPreviewBox({super.key, required this.profilePhotoBytes});

  @override
  Widget build(BuildContext context) {
    const double size = 70;
    final borderRadius = BorderRadius.circular(18);

    if (profilePhotoBytes == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: borderRadius,
        ),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: size,
        height: size,
        child: Image.memory(profilePhotoBytes!, fit: BoxFit.cover),
      ),
    );
  }
}
