import 'package:cross_file/cross_file.dart';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class AppImagePicker {
  static final AppImagePicker _singleton = AppImagePicker._internal();
  AppImagePicker._internal();

  factory AppImagePicker() => _singleton;

  Future<Uint8List> pickImage() async {
    final imageFile = await pickImageFile();
    return imageFile?.readAsBytes();
  }

  Future<XFile> pickImageFile() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;
    return XFile(pickedFile.path);
  }
}
