import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageProviders extends ChangeNotifier {

  File? file;
  ImagePicker image = ImagePicker();
  Future<void> getCam(ImageSource source) async {
    var img = await image.pickImage(source: source);
    file = File(img!.path);
    notifyListeners();
  }
}