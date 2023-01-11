// ignore_for_file: prefer_final_fields

import 'dart:developer';
import 'package:dioldifi/Utils/drawer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dioldifi/Utils/Constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Utils/LanguageDialog.dart';
import '../Utils/route.dart';
import 'AlbumPage.dart';
import 'HomePage.dart';

class LandingPage extends StatefulWidget {
  var locale;
  LandingPage({super.key, this.locale});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool islaoding = true;
  bool ispermission = true;
  checkPermissions() async {
    islaoding = true;
    Future.delayed(const Duration(seconds: 4), () {
      islaoding = false;
      if (mounted) {
        setState(() {});
      }
    });
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
  }

  @override
  void initState() {
    super.initState();
    log(widget.locale.toString());
    checkPermissions();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Container(
      color: const Color(0xffD0D0D0),
      child: SafeArea(
          child: Scaffold(
              drawer: const MainDrawer(),
              key: scaffoldKey,
              backgroundColor: const Color(0xffD0D0D0),
              body: Container(
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
                            horizontal: 8.0, vertical: 12),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      scaffoldKey.currentState?.openDrawer();
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
                                const SizedBox(
                                  width: 50,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "appname".tr(),
                              style: const TextStyle(
                                  fontFamily: "trajan",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 37,
                                  color: Colors.black),
                            ),
                            Text(
                              "slogan".tr(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: "inter",
                                  fontWeight: FontWeight.w400,
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
                                                Navigator.of(context).push(createRoute(MyAblum(isvideo: false,)));
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
                                                languagepickerdialog(context);
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
                                      InkWell(
                                        onTap: () {
                                          if (ispermission) {
                                            Navigator.of(context).push(
                                                createRoute(const HomePage()));
                                          } else {
                                            EasyLoading.showToast(
                                                "Allow permission from settings to continue");
                                            Future.delayed(
                                                const Duration(seconds: 1),
                                                () async {
                                              await openAppSettings();
                                            });
                                          }
                                        },
                                        child: Container(
                                            height: 80,
                                            width: 80,
                                            child: Image.asset(
                                                "assets/images/start.png")),
                                      ),
                                      Text(
                                        "start".tr(),
                                        style: TextStyle(
                                            fontFamily: "inter",
                                            fontWeight: FontWeight.w600,
                                            fontSize: 30,
                                            color: widget.locale.toString() ==
                                                    "ur_PK"
                                                ? Colors.black
                                                : Colors.white),
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
  }
}
