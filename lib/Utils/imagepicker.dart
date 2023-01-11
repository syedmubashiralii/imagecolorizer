import 'dart:developer';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

Future<String> pickImage(ImageSource source) async {
  final picker = ImagePicker();

  String path = '';

  try {
    final getImage = await picker.pickImage(source: source);
    if (getImage != null) {
      path = getImage.path;
    } else {
      path = '';
    }
  } catch (e) {
    EasyLoading.showToast(e.toString());
  }

  return path;
}

Future<String> pickVideo(ImageSource source) async {
  final picker = ImagePicker();

  String path = '';

  try {
    final getVideo = await picker.pickVideo(source: source);
    if (getVideo != null) {
      path = getVideo.path;
    } else {
      path = '';
    }
  } catch (e) {
    EasyLoading.showToast(e.toString());
  }

  return path;
}
