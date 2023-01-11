// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

ImagesServerRequest(File img, String url) async {
  var responseString;
  var uint;
  var request = http.MultipartRequest("POST", Uri.parse(url));
  request.files.add(await http.MultipartFile.fromPath('img', img.path));
  request.fields['factor'] = "35";
  request.headers.addAll({'Content-type': 'multipart/formdata'});
  try {
    var res = await request.send().timeout(const Duration(seconds: 30));
    if (res.statusCode == 200) {
      var responseData = await res.stream.toBytes();
      responseString = String.fromCharCodes(responseData);
      Map valueMap = await json.decode(responseString);
      var text = valueMap['responseImage'].toString();
      final bgimgbytes =
          base64.normalize((text.replaceAll(RegExp(r'\s+'), '')));
      uint = base64.decode(bgimgbytes);
    } else {
      uint = null;
      EasyLoading.showToast("Our Servers are Currently Busy, Please try again");
    }

    return uint;
  } catch (e) {
    EasyLoading.showToast("Our Servers are Currently Busy, Please try again");
    uint = null;
    return uint;
  }
}

videocolorizer(File video, String url) async {
  var uint;
  var responseString;
  var request = http.MultipartRequest("POST", Uri.parse(url));
  request.files.add(await http.MultipartFile.fromPath('video', video.path));
  request.fields['factor'] = "20";
  request.headers.addAll({'Content-type': 'multipart/formdata'});
  print('Sending request...');
  try {
    var res = await request.send().timeout(const Duration(minutes: 5));
    if (res.statusCode == 200) {
      var responseData = await res.stream.toBytes();
      responseString = String.fromCharCodes(responseData);
      Map valueMap = json.decode(responseString);
      var text = valueMap['responseVideo'].toString();
      final bgimgbytes =
          base64.normalize((text.replaceAll(RegExp(r'\s+'), '')));
      uint = base64.decode(bgimgbytes);

      return uint;
    } else {
      uint = null;
      EasyLoading.showToast(
          "Our Servers are Currently Busy, Please try again later");
      return uint;
    }
  } catch (e) {
    uint = null;
    EasyLoading.showToast(
        "Our Servers are Currently Busy, Please try again later");
    return uint;
  }
}
