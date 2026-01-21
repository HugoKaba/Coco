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

  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadImage(File file, {String? path}) async {
    try {
      final String storagePath = path ?? 'uploads/${_uuid.v4()}.jpg';
      final Reference ref = _storage.ref().child(storagePath);

      final UploadTask uploadTask = ref.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;

      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}
