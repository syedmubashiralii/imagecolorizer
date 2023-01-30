import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagesController with ChangeNotifier {
  List images = [];
  List videos = [];
  bool isloading = false;
  bool isvideoloading = false;
  FetchImages() async {
    images = [];
    isloading = true;
    notifyListeners();
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.image);
    final recentAlbum = albums.first;
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 15, // end at a very big index (to get all the assets)
    );

    for (int i = 0; i < recentAssets.length; i++) {
      File? file = await recentAssets[i].file;
      images.add({"path": file!.path});
    }
    isloading = false;
    notifyListeners();
    return images;
  }

  Fetchvideos() async {
    videos = [];
    isvideoloading = true;
    notifyListeners();
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.video);
    final recentAlbum = albums.first;
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 15, // end at a very big index (to get all the assets)
    );

    for (int i = 0; i < recentAssets.length; i++) {
      File? file = await recentAssets[i].file;
      int duration = recentAssets[i].duration;
      videos.add({
        "path": file!.path,
        "thumbnail": await recentAssets[i].thumbnailData,
        "duration": duration
      });
    }
    isvideoloading = false;
    notifyListeners();
    return videos;
  }
}
