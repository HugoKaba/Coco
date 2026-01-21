import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

final imageUploadServiceProvider = Provider((ref) => ImageUploadService());

class ImageUploadService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  /// Picks an image from the gallery.
  /// Returns the [File] if an image is selected, otherwise null.
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024, // Resize for performance
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      // Handle permission errors or picker failures
      // In a real app, you might want to log this or throw a custom exception
      return null;
    }
  }

  /// Uploads an image to Firebase Storage at the specified [path].
  /// If [path] is not provided, uploads to 'uploads/{uuid}.jpg'.
  /// Returns the download URL of the uploaded image.
  Future<String?> uploadImage(File file, {String? path}) async {
    try {
      final String storagePath = path ?? 'uploads/${_uuid.v4()}.jpg';
      final Reference ref = _storage.ref().child(storagePath);

      final UploadTask uploadTask = ref.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;

      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      // Handle upload errors (network, permission, etc.)
      return null;
    }
  }
}
