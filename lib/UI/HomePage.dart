// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:dioldifi/UI/ImagePicker.dart';
import 'package:dioldifi/UI/VideoPicker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';

import '../Utils/Constants.dart';
import '../Utils/route.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Trimmer _trimmer = Trimmer();

  @override
  void initState() {
    super.initState();
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: h * .07,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    )),
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
                        "homepage".tr(),
                        style: const TextStyle(
                            fontFamily: "trajan",
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                SizedBox(
                    height: h * .37,
                    width: w * .5,
                    child: Image.asset(
                      "assets/images/pngegg-(5)-modified-Recovered.gif",
                      fit: BoxFit.contain,
                    )),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  height: h * .2,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          Navigator.of(context).push(createRoute(ImagePickerr(
                            title: 'Imagestable',
                            url: imgstableurl,
                          )));
                        },
                        child: Container(
                          height: h * .2,
                          width: w * .45,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/button1.png"))),
                          child: Text(
                            "Imagestable".tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: "trajanbold",
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          Navigator.of(context).push(createRoute(ImagePickerr(
                            title: 'imagecolorizer',
                            url: imgartisticurl,
                          )));
                        },
                        child: Container(
                          height: h * .2,
                          alignment: Alignment.center,
                          width: w * .45,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/button2.png"))),
                          child: Text(
                            "imagecolorizer".tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: "trajanbold",
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: () async {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => ImageEditor()));
                      Navigator.of(context).push(createRoute(VideoPicker(
                        title: 'videocolorizer',
                        url: videocolorizerurl,
                      )));
                    },
                    child: Container(
                      height: h * .23,
                      alignment: Alignment.center,
                      width: w * .57,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/button3.png"))),
                      child: Text(
                        "videocolorizer".tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: "trajanbold",
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
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
