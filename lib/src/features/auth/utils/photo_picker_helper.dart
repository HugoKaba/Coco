import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickProfilePhotoHelper() async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      return await picked.readAsBytes();
    }
  } catch (e) {
    debugPrint("Erreur photo: $e");
  }
  return null;
}
