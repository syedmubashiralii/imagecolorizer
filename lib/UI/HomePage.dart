// ignore_for_file: use_build_context_synchronously

import 'dart:ui' as ui;
import 'package:dioldifi/UI/ImageEditor.dart';
import 'package:dioldifi/UI/ImagePicker.dart';
import 'package:dioldifi/UI/VideoPicker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../Controllers/Ads_Controller.dart';
import '../Controllers/CoinsController.dart';
import '../Controllers/OpenAds.dart';
import '../Utils/Constants.dart';
import '../Utils/Functions.dart';
import '../Utils/route.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool isPaused = false;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool ispermission = true;

  checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();
    statuses.values.forEach((element) async {
      if (element.isDenied || element.isPermanentlyDenied) {
        ispermission = false;
        setState(() {});
      }
    });

    return ispermission;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Provider.of<coinsController>(context, listen: false).isadfree ==
          false) {
        getads();
      }
      checkPermissions();
      //  _deleteCacheDir();
    });
    WidgetsBinding.instance.addObserver(this);

    if (Provider.of<coinsController>(context, listen: false).isadfree ==
        false) {
      appOpenAdManager.loadAd();
    }
  }

  getads() {
    final ads = Provider.of<GetAds>(context, listen: false);
    ads.HomePageBanner();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    deleteCacheDir();
    super.dispose();
  }

  @override 
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
    if (state == AppLifecycleState.resumed && isPaused) {
      print("Resumed==========================");
      checkPermissions();
      if (isopenadready) {
        if (Provider.of<coinsController>(context, listen: false).isadfree ==
            false) {
          appOpenAdManager.showAdIfAvailable();
        }
      }

      isPaused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ads = Provider.of<GetAds>(context);
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Container(
      color: appbarcolor,
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xffcccccc),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Provider.of<coinsController>(
                  context,
                ).isadfree
                    ? SizedBox(
                        height: 0,
                      )
                    : Container(
                        height: ads.ishomepagebannerloaded ? h * .07 : h * 0.03,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: ads.ishomepagebannerloaded
                            ? AdWidget(ad: ads.homePage)
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                // SizedBox(
                //   width: double.infinity,
                //   child: Image.asset("assets/images/appbarbottom.png"),
                // ),
                SizedBox(
                    height: h * .3,
                    width: w * .5,
                    child: Image.asset(
                      "assets/images/pngegg-(5)-modified-Recovered.gif",
                      fit: BoxFit.contain,
                    )),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  height: h * .2,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          if (ispermission) {
                            if (Provider.of<coinsController>(context,
                                        listen: false)
                                    .isadfree ==
                                false) {
                              if (istartadshown == false) {
                                ads.showstartint();
                              }
                            }

                            Navigator.of(context).push(createRoute(ImagePickerr(
                              title: 'Imagestable',
                              url: imgstableurl,
                              coin: 1,
                            )));
                          } else {
                            EasyLoading.showToast(
                                "Allow permission from settings to continue");
                            Future.delayed(const Duration(seconds: 1),
                                () async {
                              await openAppSettings();
                            });
                          }
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
                          if (ispermission) {
                            if (Provider.of<coinsController>(context,
                                        listen: false)
                                    .isadfree ==
                                false) {
                              if (istartadshown == false) {
                                ads.showstartint();
                              }
                            }
                            Navigator.of(context).push(createRoute(ImagePickerr(
                                title: 'imagecolorizer',
                                url: imgartisticurl,
                                coin: 2)));
                          } else {
                            EasyLoading.showToast(
                                "Allow permission from settings to continue");
                            Future.delayed(const Duration(seconds: 1),
                                () async {
                              await openAppSettings();
                            });
                          }
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
                      if (ispermission) {
                        if (Provider.of<coinsController>(context, listen: false)
                                .isadfree ==
                            false) {
                          if (istartadshown == false) {
                            ads.showstartint();
                          }
                        }
                        Navigator.of(context).push(createRoute(VideoPicker(
                          title: 'videocolorizer',
                          url: videocolorizerurl,
                        )));
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ImageEditor()));
                      } else {
                        EasyLoading.showToast(
                            "Allow permission from settings to continue");
                        Future.delayed(const Duration(seconds: 1), () async {
                          await openAppSettings();
                        });
                      }
                    },
                    child: Container(
                      height: h * .23,
                      alignment: Alignment.center,
                      width: w * .57,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/images/button3.png",
                              ),
                              fit: BoxFit.contain)),
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
