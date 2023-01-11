// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dioldifi/Utils/Constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../Controllers/AlbumController.dart';
import '../Controllers/SaveController.dart';
import '../Utils/SaveDialog.dart';
import 'AlbumPage.dart';

class VideoPlayerr extends StatefulWidget {
  File file;
  bool isalbum;
  VideoPlayerr({super.key, required this.file, required this.isalbum});

  @override
  State<VideoPlayerr> createState() => _VideoPlayerrState();
}

class _VideoPlayerrState extends State<VideoPlayerr> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    init();
  }

  init() async {
    _controller = VideoPlayerController.file(widget.file)
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Container(
      child: WillPopScope(
        onWillPop: () {
          EasyLoading.dismiss();
          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: primarycolor,
          appBar: AppBar(
            title: Text(
              "videocolorizer".tr().replaceAll("\n", " "),
              style: const TextStyle(fontFamily: "trajan"),
            ),
            backgroundColor: appbarcolor,
            elevation: 0,
            actions: widget.isalbum
                ? []
                : [
                    IconButton(
                        onPressed: () {
                          SomeDialog(
                              appName: "appname".tr(),
                              context: context,
                              path: "assets/images/sparrow.png",
                              mode: SomeMode.Asset,
                              content: "saveviddes".tr(),
                              title: "savevid".tr(),
                              submit: () async {
                                EasyLoading.show();
                                Uint8List uint =
                                    await widget.file.readAsBytes();
                                await SaveController().saveVideo(uint);
                                EasyLoading.showToast(
                                    "Video saved Successfully");
                                EasyLoading.dismiss();
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyAblum(
                                              isvideo: true,
                                            )));
                              },
                              buttonConfig: ButtonConfig(
                                buttonCancelColor: Colors.red,
                                buttonDoneColor: Colors.green,
                                labelCancelColor: Colors.white,
                                labelDoneColor: Colors.white,
                              ));
                        },
                        icon: const Icon(Icons.save))
                  ],
          ),
          body: Center(
            child: InkWell(
              onTap: () {
                _controller.play();
              },
              child: Stack(
                children: [
                  _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller))
                      : Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            color: appbarcolor,
                            strokeWidth: 2.0,
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: const BoxDecoration(color: Colors.black26),
                      child: Row(children: [
                        GestureDetector(
                          onTap: () {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                            setState(() {});
                          },
                          child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 40,
                                color: Colors.white,
                              )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ValueListenableBuilder(
                          valueListenable: _controller,
                          builder: (context, VideoPlayerValue value, child) {
                            //Do Something with the value.
                            return Text(
                              value.position.toString().split(".")[0],
                              style: const TextStyle(
                                  color: Colors.white, fontFamily: "inter"),
                            );
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: VideoProgressIndicator(_controller,
                                colors: VideoProgressColors(
                                    playedColor: appbarcolor,
                                    backgroundColor: primarycolor,
                                    bufferedColor: Colors.white),
                                allowScrubbing: true),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _controller,
                          builder: (context, VideoPlayerValue value, child) {
                            //Do Something with the value.
                            return Text(
                              value.duration.toString().split(".")[0],
                              style: const TextStyle(
                                  color: Colors.white, fontFamily: "inter"),
                            );
                          },
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: !widget.isalbum
              ? Container(
                  height: 0,
                )
              : Padding(
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
                        SizedBox(
                          height: h * .12,
                          width: w * .6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  Share.shareFiles([widget.file.path],
                                      text: 'Created by Image Colorizer Pro');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 22.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                      content: "delviddes".tr(),
                                      title: "delvid".tr(),
                                      submit: () async {
                                        await widget.file.delete();
                                        final album =
                                            Provider.of<MyAlbumController>(
                                                context,
                                                listen: false);
                                        album.getvideoalbum("Videos");
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
    );
  }
}
