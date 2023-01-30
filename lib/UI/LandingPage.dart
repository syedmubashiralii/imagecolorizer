// ignore_for_file: prefer_final_fields

import 'dart:developer';
import 'package:dioldifi/Controllers/CoinsController.dart';
import 'package:dioldifi/Utils/InAppPurchase.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:dioldifi/Utils/drawer.dart';
import 'dart:ui' as ui;
import 'package:lottie/lottie.dart';
import 'package:dioldifi/Utils/Constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controllers/Ads_Controller.dart';
import '../Controllers/LoginSignUpController.dart';
import '../Utils/Functions.dart';
import '../Utils/InApp.dart';
import '../Utils/LanguageDialog.dart';
import '../Utils/PermissionUsagedilaog.dart';
import '../Utils/route.dart';
import 'AlbumPage.dart';
import 'HomePage.dart';

class LandingPage extends StatefulWidget {
  var locale;
  LandingPage({
    super.key,
    this.locale,
    this.analytics,
    this.observer,
  });
  var analytics;
  var observer;
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isloading = true;

  var querySnapshot;

  @override
  void initState() {
    super.initState();
    isloading = true;
    Future.delayed(const Duration(seconds: 4), () {
      isloading = false;
      if (mounted) {
        setState(() {});
      }
    });
    getcoins(context);
    getadsstatuts(context);
    // sendAnalytics(widget.analytics, "landing_page");
    CurrentLocale = widget.locale.toString();

    showdialog();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Provider.of<coinsController>(context, listen: false).isadfree ==
          false) {
        getads();
      }
    });
  }

  getads() {
    final ads = Provider.of<GetAds>(context, listen: false);
    if (ads.startint == null) {
      ads.createstartint();
    }
    ads.Createalbuminiterstitial();
  }

  showdialog() async {
    var prefs = await SharedPreferences.getInstance();
    var dialog = prefs.getBool("dialog");
    if (dialog == null || dialog == false) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => PermissionUsagedialog(context));
    } else {}
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final ads = Provider.of<GetAds>(context);
    var h = MediaQuery.of(context).size.height;
    return Container(
      color: const Color(0xffD0D0D0),
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Consumer<coinsController>(builder: (context, coindata, child) {
          return Container(
            color: const Color(0xffD0D0D0),
            child: SafeArea(
                child: Scaffold(
                    drawer: const MainDrawer(),
                    key: scaffoldKey,
                    backgroundColor: const Color(0xffD0D0D0),
                    body: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: h * 0.08,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Image.asset(
                                      "assets/images/Group24.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            scaffoldKey.currentState
                                                ?.openDrawer();
                                          },
                                          icon: const Icon(Icons.menu)),
                                      Text(
                                        "version".tr(),
                                        style: const TextStyle(
                                            fontFamily: "inter",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.black),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Navigator.of(context)
                                          //     .push(createRoute(InApp()));
                                          showCupertinoModalBottomSheet(
                                              expand: false,
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) => Container(
                                                  height: h * .6,
                                                  child: inApp()));
                                        },
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                height: h * .06,
                                                child: Lottie.asset(
                                                    'assets/json/coin.json')),
                                            Text(
                                              "${coindata.totalcoins} Coins",
                                              style: const TextStyle(
                                                  fontFamily: "inter",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: CurrentLocale == "ur_PK" ||
                                            CurrentLocale == "ar_AR"
                                        ? w * .5
                                        : w * .8,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "appname".tr(),
                                        style: const TextStyle(
                                            fontFamily: "trajanbold",
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "slogan".tr(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontFamily: "inter",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.black),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 14.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: h * 0.1,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      if (Provider.of<coinsController>(
                                                                  context,
                                                                  listen: false)
                                                              .isadfree ==
                                                          false) {
                                                        ads.showalbumint();
                                                      }

                                                      Navigator.of(context)
                                                          .push(createRoute(
                                                              MyAblum(
                                                        isvideo: false,
                                                      )));
                                                    },
                                                    child: Image.asset(
                                                        "assets/images/album.png")),
                                                textwidget("album".tr())
                                              ],
                                            ),
                                            SizedBox(
                                              width: w * 0.08,
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: h * 0.1,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      languagepickerdialog(
                                                          context);
                                                      //for test crash
                                                      // FirebaseCrashlytics.instance
                                                      //     .crash();
                                                    },
                                                    child: Image.asset(
                                                        "assets/images/lang.png")),
                                                textwidget("language".tr())
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            isloading
                                                ? CircularProgressIndicator
                                                    .adaptive(
                                                    strokeWidth: 2.0,
                                                    backgroundColor:
                                                        appbarcolor,
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      if (Provider.of<coinsController>(
                                                                  context,
                                                                  listen: false)
                                                              .isadfree ==
                                                          false) {
                                                        ads.showstartint();
                                                      }
                                                      Navigator.of(context)
                                                          .push(createRoute(
                                                              const HomePage()));
                                                    },
                                                    child: SizedBox(
                                                        height: 80,
                                                        width: 80,
                                                        child: Image.asset(
                                                            "assets/images/start.png")),
                                                  ),
                                            SizedBox(
                                              width: 60,
                                              child: FittedBox(
                                                child: Text(
                                                  "start".tr(),
                                                  style: TextStyle(
                                                      fontFamily: "inter",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 22,
                                                      color: widget.locale
                                                                  .toString() ==
                                                              "ur_PK"
                                                          ? Colors.black
                                                          : Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )))),
          );
        }),
      ),
    );
  }
}
