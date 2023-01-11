
import 'package:dioldifi/Utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

Future<String> imageCropperView(String? path) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: path!,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    uiSettings: [
      AndroidUiSettings(
          activeControlsWidgetColor: appbarcolor,
          showCropGrid: false,
          toolbarTitle: 'Crop Image',
          toolbarColor: appbarcolor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(title: 'Crop Image', doneButtonTitle: "Proceed"),
    ],
  );

  if (croppedFile != null) {
    return croppedFile.path;
  } else {
    return '';
  }
}
