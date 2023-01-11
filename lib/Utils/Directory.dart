import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> getdirectory(String folder) async {
  var appDocPath;
  Directory appDocDir = await getApplicationDocumentsDirectory();
  appDocPath = appDocDir.path;
  print(appDocPath);
  bool directoryExists = await Directory('${appDocPath}/$folder').exists();
  if (!directoryExists) {
    await Directory('${appDocPath}/$folder').create(recursive: true);
  }
  final fullPath =
      '${appDocPath}/$folder/Deoldifiy${DateTime.now().microsecondsSinceEpoch}.png';
  return fullPath;
}
