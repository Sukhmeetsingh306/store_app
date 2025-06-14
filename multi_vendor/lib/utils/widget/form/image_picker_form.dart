import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerForm {
  File? imageFile;
  Uint8List? webImage;

  Future<void> pickImage(Function(File?, Uint8List?) onImagePicked) async {
    final ImagePicker picker = ImagePicker();

    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        var status = await Permission.photos.request();
        if (status.isDenied || status.isPermanentlyDenied) {
          openAppSettings();
          return;
        }
      }
    }

    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        webImage = bytes;
        onImagePicked(null, bytes);
      } else {
        imageFile = File(pickedFile.path);
        onImagePicked(imageFile, null);
      }
    }
  }
}
