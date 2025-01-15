import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class UserProvider extends ChangeNotifier{
  bool _isObscure = false;
  File? _img;

  bool get isObscure => _isObscure;

  File? get image => _img;

  void toggleVisibility() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _img = File(pickedFile.path);
        print(_img!.path);
        notifyListeners();
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadImage() async {
    if (_img == null) return;
    notifyListeners();
    try {
      String fileName = path.basename(_img!.path);
      Reference storageRef =
      FirebaseStorage.instance.ref().child('profile_pictures/$fileName');
      await storageRef.putFile(_img!);
      String downloadUrl = await storageRef.getDownloadURL();
      await FirebaseAuth.instance.currentUser?.updatePhotoURL(downloadUrl);
    } catch (e) {
      print('Error uploading image: $e');
    } finally {
      notifyListeners();
    }
  }

}