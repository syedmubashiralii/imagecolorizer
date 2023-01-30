// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Controllers/ApiController.dart';
import '../Utils/Constants.dart';
import '../Utils/Directory.dart';
import '../Utils/route.dart';
import 'ImageEditor.dart';
import 'Videoplayer.dart';

class LoadingPage extends StatefulWidget {
  String path;
  String url;
  bool isimage;
  int coin;
  LoadingPage(
      {Key? key,
      required this.path,
      required this.url,
      required this.isimage,
      required this.coin})
      : super(key: key);
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    if (widget.isimage) {
      asyncimginitstate();
    } else {
      asyncvideoinitstate();
    }
  }

  asyncvideoinitstate() async {
    var uint = await videocolorizer(File(widget.path), widget.url);
    if (uint == null) {
      Navigator.pop(context);

      return;
    } else {
      var path = await getdirectory("videos");
      var enhance = File(path);
      await enhance.writeAsBytes(uint);

      Navigator.of(context).pushReplacement(createRoute(VideoPlayerr(
        file: enhance,
        isalbum: false,
      )));
    }
  }

  asyncimginitstate() async {
    var uint = await ImagesServerRequest(File(widget.path), widget.url);

    if (uint == null) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.of(context).pushReplacement(
          createRoute(ImageEditor(img: uint, coin: widget.coin)));
    }
  }

  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        color: const Color(0xffcccccc),
        child: SafeArea(
          top: true,
          bottom: true,
          child: Scaffold(
            backgroundColor: const Color(0xffcccccc),
            body: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                    height: h * .3,
                    width: w * .5,
                    child: Image.asset(
                      "assets/images/pngegg-(5)-modified-Recovered.gif",
                      fit: BoxFit.contain,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "loadingdialogtext".tr(),
                  style: const TextStyle(
                      fontFamily: "trajanbold",
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: LinearProgressIndicator(
                //     minHeight: 6,
                //     color: appbarcolor,
                //     backgroundColor: Colors.white,
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  height: h * .2,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          launchUrl(Uri.parse(
                              "https://play.google.com/store/apps/details?id=com.appexsoft.sketching.pencilsketch"));
                        },
                        child: Container(
                          height: h * .2,
                          width: w * .45,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/oneclicktwocut.png"))),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          launchUrl(Uri.parse(
                              "https://play.google.com/store/apps/details?id=com.appexsoft.sketching.pencilsketch"));
                        },
                        child: Container(
                          height: h * .2,
                          width: w * .45,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/sketchit.png"))),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: () async {
                      launchUrl(Uri.parse(
                          "https://play.google.com/store/apps/details?id=com.appexsoft.zoomgrid.photo.enhance"));
                    },
                    child: Container(
                      height: h * .23,
                      width: w * .57,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/images/zoomgrid.png",
                              ),
                              fit: BoxFit.contain)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
