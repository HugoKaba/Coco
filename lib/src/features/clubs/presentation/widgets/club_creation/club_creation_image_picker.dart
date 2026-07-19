import 'dart:io';

import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/shared/services/image_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubCreationImagePicker extends ConsumerStatefulWidget {
  const ClubCreationImagePicker({super.key, required this.onImageUploaded});

  final ValueChanged<String> onImageUploaded;

  @override
  ConsumerState<ClubCreationImagePicker> createState() =>
      _ClubCreationImagePickerState();
}

class _ClubCreationImagePickerState
    extends ConsumerState<ClubCreationImagePicker> {
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickAndUploadImage() async {
    final imageService = ref.read(imageUploadServiceProvider);
    final file = await imageService.pickImageFromGallery();
    if (file == null) return;

    setState(() {
      _selectedImage = file;
      _isUploading = true;
    });

    final url = await imageService.uploadImage(
      file,
      path: 'clubs/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    if (!mounted) return;

    setState(() => _isUploading = false);
    if (url == null) {
      setState(() => _selectedImage = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'envoyer l'image")),
      );
      return;
    }

    widget.onImageUploaded(url);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: _isUploading ? null : _pickAndUploadImage,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: Theme.of(context).dividerColor),
          image: _selectedImage == null
              ? null
              : DecorationImage(
                  image: FileImage(_selectedImage!),
                  fit: BoxFit.cover,
                ),
        ),
        child: _isUploading
            ? const Center(child: CircularProgressIndicator())
            : _selectedImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_rounded,
                    size: 40,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Ajouter une image du club',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
