import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage(bool isCamera) async {
  final pickedImage = await ImagePicker().pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 20);
  if (pickedImage == null) {
    return null;
  }
  return File(pickedImage.path);
}