import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dark_text_field.dart';
import 'input_wrapper.dart';

class PhotoPickerField extends StatelessWidget {
  final Uint8List? profilePhotoBytes;
  final VoidCallback onTap;
  final Color fieldColor;
  final Color innerShadow;

  const PhotoPickerField({
    super.key,
    required this.profilePhotoBytes,
    required this.onTap,
    required this.fieldColor,
    required this.innerShadow,
  });

  @override
  Widget build(BuildContext context) {
    final label = profilePhotoBytes == null ? "image.jpg" : "Selected Image";
    return InputWrapper(
      borderRadius: 20,
      fieldColor: fieldColor,
      innerShadow: innerShadow,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.photo_library_rounded, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}
