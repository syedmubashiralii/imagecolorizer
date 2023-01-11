import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class SaveController {
  saveImage(var img) async {
    // final image = await widget.Img.exportImage();
    Directory? directory = await getApplicationDocumentsDirectory();
    bool directoryExists =
        await Directory('${directory.path}/Pictures').exists();
    if (!directoryExists) {
      await Directory('${directory.path}/Pictures').create(recursive: true);
    }
    final fullPath =
        '${directory.path}/Pictures/CMP${DateTime.now().millisecondsSinceEpoch}.png';
    File imageFile = File(fullPath);
    imageFile.writeAsBytes(img!);
    GallerySaver.saveImage(imageFile.path, albumName: 'Color Magic Pro')
        .then((value) {});
  }

  saveVideo(var video) async {
    // final image = await widget.Img.exportImage();
    Directory? directory = await getApplicationDocumentsDirectory();
    bool directoryExists = await Directory('${directory.path}/Videos').exists();
    if (!directoryExists) {
      await Directory('${directory.path}/Videos').create(recursive: true);
    }
    final fullPath =
        '${directory.path}/Videos/CMP${DateTime.now().millisecondsSinceEpoch}.mp4';
    File videoFile = File(fullPath);
    await videoFile.writeAsBytes(video!);
    GallerySaver.saveVideo(videoFile.path, albumName: 'Color Magic Pro')
        .then((value) {});
  }
}
