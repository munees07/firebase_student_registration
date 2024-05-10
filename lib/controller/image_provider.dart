import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageProviders extends ChangeNotifier {

  File? pickedImage;
  ImagePicker image = ImagePicker();
  Future<void> pickImage(ImageSource source) async {
    var img = await image.pickImage(source: source);
    pickedImage = File(img!.path);
    notifyListeners();
  }
  
  void clearPickedImage() {
    pickedImage = null;
    notifyListeners();
  }
}