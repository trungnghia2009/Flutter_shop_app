import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Avatar with ChangeNotifier {
  String _authToken;
  String _userId;
  String _avatarUrl;
  File _imageFile;

  void updateToken(String tokenValue, String userIdValue) {
    _authToken = tokenValue;
    _userId = userIdValue;
  }

  String get avatarUrl {
    return _avatarUrl;
  }

  File get imageFile {
    return _imageFile;
  }

  void resetImageFile() {
    _imageFile = null;
  }

  Future<void> getImage() async {
    final pickedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    _imageFile = pickedImage;
    notifyListeners();
  }

  Future<void> uploadAvatar() async {
    // TODO: get image name
    final fileName = basename(_imageFile.path);

    // TODO: compress image, keep aspect ratio
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(_imageFile.path);
    File compressedFile = await FlutterNativeImage.compressImage(
        _imageFile.path,
        quality: 80,
        targetWidth: 500,
        targetHeight: (properties.height * 500 / properties.width).round());

    // TODO: upload image
    final StorageReference storageReference =
        FirebaseStorage().ref().child(fileName);
    final StorageUploadTask uploadTask =
        storageReference.putFile(compressedFile);

    //TODO: check if it completed, and get url
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    final url =
        'https://flutter-shop-app-b7959.firebaseio.com/avatar/$_userId.json?auth=$_authToken';

    // TODO: update avatar to database
    final respond = await http.put(url, body: json.encode(downloadUrl));
    _imageFile = compressedFile;
    _avatarUrl = downloadUrl;
  }

  Future<void> fetchAvatarUrl() async {
    final url =
        'https://flutter-shop-app-b7959.firebaseio.com/avatar/$_userId.json?auth=$_authToken';
    final respond = await http.get(url);
    final avatarData = jsonDecode(respond.body);
    print('--------------------------------');
    print(avatarData);
    _avatarUrl = avatarData;
    notifyListeners();
  }
}
