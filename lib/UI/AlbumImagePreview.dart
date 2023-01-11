// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../Controllers/AlbumController.dart';
import '../Utils/Constants.dart';
import '../Utils/SaveDialog.dart';

class ImagePreview extends StatefulWidget {
  String file;
  ImagePreview({super.key, required this.file});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  void initState() {
    super.initState();
    log(widget.file);
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Container(
      color: appbarcolor,
      child: WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xffcccccc),
            body: Column(
              children: [
                Container(
                  height: h * .068,
                  color: appbarcolor,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      SizedBox(
                        width: w * .02,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: w * .06,
                      ),
                      Text(
                        widget.file.split("Pictures/")[1].split(".png")[0],
                        style: const TextStyle(
                            fontFamily: "trajan",
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Image.file(
                  File(widget.file),
                  fit: BoxFit.contain,
                )),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: w * .22),
                height: h * .12,
                width: w * .6,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/images/gallerycamera.png"),
                    Container(
                      height: h * .12,
                      width: w * .6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Share.shareFiles([widget.file],
                                  text: 'Created by Image Colorize4r Pro');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 22.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.share,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  Text(
                                    "share".tr(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () async {
                              SomeDialog(
                                  appName: "appname".tr(),
                                  context: context,
                                  path: "assets/images/sparrow.png",
                                  mode: SomeMode.Asset,
                                  content: "delimgdes".tr(),
                                  title: "delimg".tr(),
                                  submit: () async {
                                    await File(widget.file).delete();
                                    final album =
                                        Provider.of<MyAlbumController>(context,
                                            listen: false);
                                    album.getalbum("Pictures");
                                    Navigator.pop(context);
                                  },
                                  buttonConfig: ButtonConfig(
                                    buttonCancelColor: Colors.red,
                                    buttonDoneColor: Colors.green,
                                    labelCancelColor: Colors.white,
                                    labelDoneColor: Colors.white,
                                  ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  Text(
                                    "del".tr(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
