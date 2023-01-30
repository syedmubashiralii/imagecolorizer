import 'dart:io';
import 'package:dioldifi/UI/AlbumImagePreview.dart';
import 'package:dioldifi/Utils/Constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import '../Controllers/Ads_Controller.dart';
import '../Controllers/AlbumController.dart';
import '../Controllers/CoinsController.dart';
import '../Utils/Functions.dart';
import '../Utils/route.dart';
import 'Videoplayer.dart';

class MyAblum extends StatefulWidget {
  bool isvideo;
  MyAblum({Key? key, required this.isvideo}) : super(key: key);

  @override
  State<MyAblum> createState() => _MyAblumState();
}

class _MyAblumState extends State<MyAblum> {
  bool isvideo = false;
  bool isimage = true;

  @override
  void initState() {
    super.initState();

    if (widget.isvideo == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<MyAlbumController>(context, listen: false)
            .getvideoalbum('Videos');
      });
      isvideo = true;
      isimage = false;
      setState(() {});
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<MyAlbumController>(context, listen: false)
            .getalbum('Pictures');
      });
      isvideo = false;
      isimage = true;
      setState(() {});
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Provider.of<coinsController>(context, listen: false).isadfree ==
          false) {
        getads();
      }
    });
  }

  getads() {
    final ads = Provider.of<GetAds>(context, listen: false);
    ads.AlbumPageBanner();
  }

  @override
  void dispose() {
    super.dispose();

    //deleteCacheDir();
  }

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final ads = Provider.of<GetAds>(context);
    var h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Container(
          color: primarycolor,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: primarycolor,
              body: Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    Provider.of<coinsController>(
                              context,
                            ).isadfree ==
                            true
                        ? SizedBox(
                            height: 0,
                          )
                        : Container(
                            height: ads.isalbumpagebannerloaded
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
                            child: ads.isalbumpagebannerloaded
                                ? AdWidget(ad: ads.albumpage)
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
                            isvideo ? "video".tr() : "image".tr(),
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
                      child: Consumer<MyAlbumController>(
                          builder: (context, value, child) {
                        return SizedBox(
                          height: 800,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Consumer<MyAlbumController>(
                                builder: (context, value, child) {
                              return value.isloading == true
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: appbarcolor,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : value.isloading == false &&
                                          value.allimageslist.isEmpty
                                      ? Center(
                                          child: Text(
                                            isimage
                                                ? "noimages".tr()
                                                : "novideos".tr(),
                                            style: TextStyle(
                                                fontFamily: "trajanbold",
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: appbarcolor),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: GridView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount:
                                                value.allimageslist.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    childAspectRatio: 3 / 4,
                                                    crossAxisCount: 3,
                                                    crossAxisSpacing: 4,
                                                    mainAxisSpacing: 4),
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () async {
                                                  if (isimage) {
                                                    Navigator.of(context).push(
                                                        createRoute(ImagePreview(
                                                            file: value
                                                                    .allimageslist[
                                                                index])));
                                                  } else {
                                                    Navigator.of(context).push(
                                                        createRoute(
                                                            VideoPlayerr(
                                                      file: File(value
                                                          .videolist[index]),
                                                      isalbum: true,
                                                    )));
                                                  }
                                                },
                                                child: Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: isvideo
                                                            ? Stack(
                                                                fit: StackFit
                                                                    .expand,
                                                                children: [
                                                                  Opacity(
                                                                    opacity: .8,
                                                                    child: Image
                                                                        .memory(
                                                                      value.allimageslist[
                                                                          index],
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  const Center(
                                                                    child: CircleAvatar(
                                                                        backgroundColor: Colors.black45,
                                                                        radius: 18,
                                                                        child: Icon(
                                                                          Icons
                                                                              .play_arrow,
                                                                          size:
                                                                              22,
                                                                        )),
                                                                  ),
                                                                ],
                                                              )
                                                            : Image.file(
                                                                File(value
                                                                        .allimageslist[
                                                                    index]),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                      ),
                                                      Container(
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: appbarcolor,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            isvideo
                                                                ? value.videolist[
                                                                            index]
                                                                        .toString()
                                                                        .split("Videos/")[
                                                                            1]
                                                                        .split(
                                                                            ".mp4")[
                                                                    0]
                                                                : value
                                                                    .allimageslist[
                                                                        index]
                                                                    .toString()
                                                                    .split("Pictures/")[
                                                                        1]
                                                                    .split(
                                                                        ".")[0]
                                                                    .replaceAll(
                                                                        "_",
                                                                        ":")
                                                                    .split(
                                                                        ".png")[0],
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    "poppins",
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                            }),
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),
              bottomNavigationBar:
                  Consumer<MyAlbumController>(builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: w * .22),
                    height: h * .12,
                    width: w * .6,
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                            // isvideo == false && isimage == false
                            //   ?
                            // "assets/images/gallerycamera.png"
                            "assets/images/ovalbutton.png"
                            // : isimage
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
                                  isimage = true;
                                  isvideo = false;
                                  value.getalbum('Pictures');
                                  setState(() {});
                                },
                                //                               onPanUpdate: (details) {
                                //                                 // Swiping in right direction.
                                //                                 if (details.delta.dx > 0) {
                                //                                   isimage = false;
                                //                                   isvideo = true;
                                //                                   value.getvideoalbum('Videos');
                                //                                   setState(() {});
                                //                                 }
                                //                                 // Swiping in left direction.
                                //                                 if (details.delta.dx < 0) {
                                // //for urdu
                                //                                   // isimage = false;
                                //                                   // isvideo = true;
                                //                                   // value.getvideoalbum('Videos');
                                //                                   // setState(() {});
                                //                                 }
                                //                               },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20.0,
                                      right: CurrentLocale == "ur_PK" ||
                                              CurrentLocale == "ar_AR"
                                          ? 20
                                          : 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        PhosphorIcons.image,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      Text(
                                        "image".tr(),
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
                                  isopenadready = true;
                                  isimage = false;
                                  isvideo = true;
                                  await value.getvideoalbum('Videos');
                                  setState(() {});
                                },
                                // onPanUpdate: (details) async {
                                //   // Swiping in right direction.
                                //   if (details.delta.dx > 0) {
                                //     //for urdu
                                //     // isimage = true;
                                //     // isvideo = false;
                                //     // await value.getalbum('Pictures');
                                //     // setState(() {});
                                //   }
                                //   // Swiping in left direction.
                                //   if (details.delta.dx < 0) {
                                //     isimage = true;
                                //     isvideo = false;
                                //     await value.getalbum('Pictures');
                                //     setState(() {});
                                //   }
                                // },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 20.0,
                                      left: CurrentLocale == "ur_PK" ||
                                              CurrentLocale == "ar_AR"
                                          ? 20
                                          : 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        PhosphorIcons.videoCamera,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      Text(
                                        "video".tr(),
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
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  //ads

}
