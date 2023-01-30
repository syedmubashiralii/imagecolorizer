import 'dart:io';
import 'package:dioldifi/Controllers/LoginSignUpController.dart';
import 'package:dioldifi/UI/AlbumPage.dart';
import 'package:dioldifi/UI/LoginPage.dart';
import 'package:dioldifi/Utils/Constants.dart';
import 'package:dioldifi/Utils/Exitdialog.dart';
import 'package:dioldifi/Utils/route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Controllers/Ads_Controller.dart';
import '../Controllers/CoinsController.dart';
import '../UI/HomePage.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => MainDrawerState();
}

class MainDrawerState extends State<MainDrawer> {
  bool isclickedpress = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  getads() {
    final ads = Provider.of<GetAds>(context, listen: false);
    if (ads.albumint == null) {
      ads.Createalbuminiterstitial();
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final ads = Provider.of<GetAds>(context);
    return Drawer(
      width: w * .7,
      child: Container(
        color: primarycolor.withOpacity(.8),
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: h * .07,
                  ),
                  SizedBox(
                      height: h * .15,
                      child: Image.asset("assets/images/sparrow.png")),
                  SizedBox(
                    height: h * .01,
                  ),
                  Text(
                    "appname".tr(),
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "trajanbold",
                      color: secondarycolor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(
                    height: h * .01,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      "slogan".tr(),
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontFamily: "inter",
                        fontSize: 12,
                        color: secondarycolor,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: h * .06,
            ),
            items(
                text: "myalbum".tr(),
                ic: Icons.photo_album_outlined,
                ontap: () {
                  if (Provider.of<coinsController>(context, listen: false)
                          .isadfree ==
                      false) {
                    ads.showalbumint();
                  }

                  Navigator.of(context).push(createRoute(MyAblum(
                    isvideo: false,
                  )));
                }),
            items(
                text: "privacy".tr(),
                ic: Icons.privacy_tip_outlined,
                ontap: () async {
                  if (Platform.isAndroid) {
                    launchUrl(Uri.parse(
                        "https://sites.google.com/view/color-magic-pro/privacy_policy?pli=1"));
                  } else if (Platform.isIOS) {
                    launchUrl(Uri.parse(
                        "https://sites.google.com/view/color-magic-privacy-policy/home"));
                  }
                }),
            Visibility(
              visible: Platform.isAndroid,
              child: items(
                  text: "more".tr(),
                  ic: Icons.apps,
                  ontap: () async {
                    var url =
                        'https://play.google.com/store/apps/dev?id=7229798272352696433';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                    }
                  }),
            ),
            Visibility(
              visible: Platform.isAndroid,
              child: items(
                  text: "rate".tr(),
                  ic: Icons.thumb_up_alt_rounded,
                  ontap: () async {
                    var url = '';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                    }
                  }),
            ),
            items(
                text: "feedback".tr(),
                ic: Icons.feedback_outlined,
                ontap: () {
                  if (Platform.isAndroid) {
                    launchUrl(Uri(
                      scheme: 'mailto',
                      path: 'chrismaapps@gmail.com',
                      query: 'Color Magic Pro',
                    ));
                  } else if (Platform.isIOS) {
                    launchUrl(Uri(
                      scheme: 'mailto',
                      path: 'skhastech@gmail.com',
                      query: 'Color Magic Pro',
                    ));
                  }
                }),
            const Expanded(child: SizedBox()),
            Align(
              alignment: Alignment.bottomCenter,
              child: items(
                  text: "exit".tr(),
                  ic: Icons.exit_to_app,
                  ontap: () {
                    LoginSignup().SignOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                    //ExitDialog(context);
                  }),
            ),
            SizedBox(
              height: h * .03,
            ),
          ],
        ),
      ),
    );
  }
}

class items extends StatefulWidget {
  String text;
  IconData ic;
  VoidCallback ontap;
  items({Key? key, required this.text, required this.ic, required this.ontap})
      : super(key: key);

  @override
  State<items> createState() => _itemsState();
}

class _itemsState extends State<items> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Container(
        height: h * 0.05,
        child: ListTile(
          leading: Icon(
            widget.ic,
            size: 28,
            color: secondarycolor,
          ),
          title: Text(
            widget.text,
            style: TextStyle(
                color: secondarycolor, fontFamily: "poppins", fontSize: 13),
          ),
          onTap: widget.ontap,
        ),
      ),
    );
  }
}

buildMenuItem(String s, {bool active = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: InkWell(
      onTap: () {},
      child: Text(
        s.toUpperCase(),
        style: TextStyle(
          fontSize: 22,
          color: active ? const Color(0xffffffff) : null,
          fontWeight: FontWeight.w900,
        ),
      ),
    ),
  );
}
