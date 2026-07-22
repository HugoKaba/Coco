import 'dart:io';

import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/shared/services/image_upload_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubCreationImagePicker extends ConsumerStatefulWidget {
  const ClubCreationImagePicker({super.key, required this.onImageSelected});

  final ValueChanged<File> onImageSelected;

  @override
  ConsumerState<ClubCreationImagePicker> createState() =>
      _ClubCreationImagePickerState();
}

class _ClubCreationImagePickerState
    extends ConsumerState<ClubCreationImagePicker> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final imageService = ref.read(imageUploadServiceProvider);
    final file = await imageService.pickImageFromGallery();
    if (file == null) return;

    setState(() {
      _selectedImage = file;
    });
    widget.onImageSelected(file);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: _pickImage,
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
        child: _selectedImage == null
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
                    'clubs.create.add_image'.tr(),
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
