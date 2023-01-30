import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MyAlbumController extends ChangeNotifier {
  bool isloading = true;
  var dir2;
  var dir;
  var ImagesPath;
  var videospath;
  List allimageslist = [];
  List videolist = [];
  getalbum(String folder) async {
    isloading = true;
    notifyListeners();
    allimageslist = [];
    var appDir = await getApplicationDocumentsDirectory();
    dir2 = Directory('${appDir.path}/$folder');
    ImagesPath = '${appDir.path}/$folder';
    bool directoryExists = await Directory(ImagesPath).exists();
    if (directoryExists) {
      List<FileSystemEntity> files = dir2!.listSync();
      for (FileSystemEntity f1 in files) {
        allimageslist.add(f1.absolute.path);
      }
      allimageslist = allimageslist.reversed.toList();
    }

    isloading = false;
    notifyListeners();
  }

  getvideoalbum(String folder) async {
    isloading = true;
    notifyListeners();
    allimageslist = [];
    videolist = [];
    var appDir = await getApplicationDocumentsDirectory();
    dir = Directory('${appDir.path}/$folder');
    videospath = '${appDir.path}/$folder';
    bool directoryExists = await Directory(videospath).exists();
    if (directoryExists) {
      List<FileSystemEntity> files = dir!.listSync();
      for (FileSystemEntity f1 in files) {
        allimageslist.add(f1.absolute.path);
      } 
      allimageslist = allimageslist.reversed.toList();
      videolist = allimageslist;
      allimageslist = [];
    } else {}
    for (int i = 0; i < videolist.length; i++) {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: videolist[i],
        imageFormat: ImageFormat.JPEG,
        maxWidth:
            128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 100,
      );
      allimageslist.add(uint8list);
    }

    isloading = false;
    notifyListeners();
  }
}
