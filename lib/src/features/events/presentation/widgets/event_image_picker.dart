import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/shared/services/image_upload_service.dart';

class EventImagePicker extends ConsumerStatefulWidget {
  final String? initialImageUrl;
  final Function(String) onImageUploaded;

  const EventImagePicker({
    super.key,
    this.initialImageUrl,
    required this.onImageUploaded,
  });

  @override
  ConsumerState<EventImagePicker> createState() => _EventImagePickerState();
}

class _EventImagePickerState extends ConsumerState<EventImagePicker> {
  File? _selectedImage;
  String? _uploadedImageUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _uploadedImageUrl = widget.initialImageUrl;
  }

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
      path: 'events/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    if (mounted) {
      setState(() {
        _isUploading = false;
        if (url != null) {
          _uploadedImageUrl = url;
          widget.onImageUploaded(url);
        } else {
          _selectedImage = null;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(tr('errors.upload_failed'))));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isUploading ? null : _pickAndUploadImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          image: _selectedImage != null
              ? DecorationImage(
                  image: FileImage(_selectedImage!),
                  fit: BoxFit.cover,
                )
              : _uploadedImageUrl != null
              ? DecorationImage(
                  image: NetworkImage(_uploadedImageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _isUploading
            ? const Center(child: CircularProgressIndicator())
            : _selectedImage == null && _uploadedImageUrl == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_rounded,
                    size: 40,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tr('events.add_photo'),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
