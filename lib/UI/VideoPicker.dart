// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:dioldifi/UI/Videoplayer.dart';
import 'package:dioldifi/Utils/Constants.dart';
import 'package:dioldifi/Utils/SaveDialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../Controllers/Ads_Controller.dart';
import '../Controllers/ApiController.dart';
import '../Controllers/CoinsController.dart';
import '../Controllers/ImagesController.dart';
import 'dart:ui' as ui;
import '../Utils/Directory.dart';
import '../Utils/Functions.dart';
import '../Utils/Loadingdialog.dart';
import '../Utils/check_connectivity.dart';
import '../Utils/imagepicker.dart';
import '../Utils/route.dart';
import 'LoadingPage.dart';

class VideoPicker extends StatefulWidget {
  String title;
  String url;
  VideoPicker({super.key, required this.title, required this.url});

  @override
  State<VideoPicker> createState() => _VideoPickerState();
}

class _VideoPickerState extends State<VideoPicker> {
  bool isgallery = false;
  bool iscamera = true;
  List Videos = [];
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getvideos();
      if (Provider.of<coinsController>(context, listen: false).isadfree ==
          false) {
        getads();
      }
    });
  }

  getvideos() async {
    final applicationBloc =
        Provider.of<ImagesController>(context, listen: false);
    Videos = await applicationBloc.Fetchvideos();
  }

  getads() {
    final ads = Provider.of<GetAds>(context, listen: false);
    ads.VideoPickerPageBanner();
  }

  @override
  void dispose() {
    super.dispose();
    deleteCacheDir();
  }

  @override
  Widget build(BuildContext context) {
    final ads = Provider.of<GetAds>(context);
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: primarycolor,
          body: Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  Provider.of<coinsController>(context, listen: false)
                              .isadfree ==
                          true
                      ? SizedBox(
                          height: 0,
                        )
                      : Container(
                          height: ads.isvideopickerpagebannerloaded
                              ? h * .07
                              : h * 0.03,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: ads.isvideopickerpagebannerloaded
                              ? AdWidget(ad: ads.videopickerpage)
                              : const Center(
                                  child: Text("Advertisment"),
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
                            // Navigator.of(context)
                            //     .push(createRoute(ImageEditor()));
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
                          widget.title.tr().replaceAll("\n", " "),
                          style: const TextStyle(
                              fontFamily: "trajan",
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<ImagesController>(
                          builder: (context, value, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: value.isvideoloading == true
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: appbarcolor,
                                    strokeWidth: 2,
                                  ),
                                )
                              : value.isvideoloading == false && Videos.isEmpty
                                  ? Center(
                                      child: Text(
                                        "novideos".tr(),
                                        style: TextStyle(
                                            fontFamily: "trajanbold",
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: appbarcolor),
                                      ),
                                    )
                                  : GridView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: Videos.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 3 / 4,
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 4,
                                              mainAxisSpacing: 4),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () async {
                                            var outpath;
                                            if (await isDeviceConnected()) {
                                              if (Videos[index]["path"] == '') {
                                              } else {
                                                Navigator.of(context).push(
                                                    createRoute(LoadingPage(
                                                  path: Videos[index]["path"],
                                                  url: widget.url,
                                                  isimage: false,
                                                  coin: 0,
                                                )));
                                              }
                                            } else {
                                              SomeDialog(
                                                  appName: "Color Magic Pro",
                                                  context: context,
                                                  path:
                                                      "assets/images/sparrow.png",
                                                  mode: SomeMode.Asset,
                                                  content:
                                                      "Check Your intenet Connection and try again?",
                                                  title:
                                                      "No Internet Connection",
                                                  submit: () {
                                                    Navigator.pop(context);
                                                  },
                                                  buttonConfig: ButtonConfig(
                                                    buttonCancelColor:
                                                        Colors.red,
                                                    buttonDoneColor:
                                                        Colors.green,
                                                    labelCancelColor:
                                                        Colors.white,
                                                    labelDoneColor:
                                                        Colors.white,
                                                  ));
                                            }
                                          },
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Opacity(
                                                opacity: .8,
                                                child: Image.memory(
                                                  Videos[index]["thumbnail"],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const Center(
                                                child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.black45,
                                                    radius: 18,
                                                    child: Icon(
                                                      Icons.play_arrow,
                                                      size: 22,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                        );
                      }),
                    ),
                  ),
                ],
              )),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: w * .22),
              height: h * .12,
              width: w * .6,
              // color: primarycolor,
              color: Colors.transparent,
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Image.asset(

                      // isgallery == false && iscamera == false
                      //   ?
                      // "assets/images/gallerycamera.png"
                      "assets/images/ovalbutton.png"
                      // : iscamera
                      //     ? "assets/images/Group 240 (1).png"
                      //     : "assets/images/Group 240.png"
                      ),
                  Container(
                    height: h * .12,
                    width: w * .6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            isopenadready = true;
                            iscamera = true;
                            isgallery = false;
                            setState(() {});
                            ontap(ImageSource.camera);
                          },
                          onPanUpdate: (details) {
                            // Swiping in right direction.
                            if (details.delta.dx > 0) {
                              iscamera = false;
                              isgallery = true;
                              setState(() {});
                            }
                            // Swiping in left direction.
                            if (details.delta.dx < 0) {}
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 20.0,
                                right: CurrentLocale == "ur_PK" ||
                                        CurrentLocale == "ar_AR"
                                    ? 20
                                    : 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  CupertinoIcons.camera,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                Text(
                                  "camera".tr(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: w * .19,
                        ),
                        GestureDetector(
                          onTap: () async {
                            iscamera = false;
                            isopenadready = true;
                            isgallery = true;
                            setState(() {});
                            ontap(ImageSource.gallery);
                          },
                          onPanUpdate: (details) {
                            // Swiping in right direction.
                            if (details.delta.dx > 0) {}

                            // Swiping in left direction.
                            if (details.delta.dx < 0) {
                              iscamera = true;
                              isgallery = false;
                              setState(() {});
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 20.0,
                                left: CurrentLocale == "ur_PK" ||
                                        CurrentLocale == "ar_AR"
                                    ? 20
                                    : 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.photo_album_outlined,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                Text(
                                  "gallery".tr(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
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

  ontap(ImageSource source) async {
    var outpath;
    if (await isDeviceConnected()) {
      var path = await pickVideo(source);
      if (path == '') {
      } else {
        VideoPlayerController fileVideocontroller =
            VideoPlayerController.file(File(path))..initialize().then((_) {});
        debugPrint("========${fileVideocontroller.value.duration}");

        Navigator.of(context).push(createRoute(LoadingPage(
          path: path,
          url: widget.url,
          isimage: false,
          coin: 5,
        )));
      }
    } else {
      SomeDialog(
          appName: "Color Magic Pro",
          context: context,
          path: "assets/images/sparrow.png",
          mode: SomeMode.Asset,
          content: "Check Your intenet Connection and try again?",
          title: "No Internet Connection",
          submit: () {
            Navigator.pop(context);
          },
          buttonConfig: ButtonConfig(
            buttonCancelColor: Colors.red,
            buttonDoneColor: Colors.green,
            labelCancelColor: Colors.white,
            labelDoneColor: Colors.white,
          ));
    }
  }
}
