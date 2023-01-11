import 'dart:io';
import 'package:dioldifi/UI/AlbumPage.dart';
import 'package:dioldifi/Utils/Constants.dart';
import 'package:dioldifi/Utils/Exitdialog.dart';
import 'package:dioldifi/Utils/route.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../UI/HomePage.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => MainDrawerState();
}

class MainDrawerState extends State<MainDrawer> {
  bool isclickedpress = false;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
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
                    "Color Magic Pro",
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
                  Text(
                    textAlign: TextAlign.center,
                    "Bring new life to old black and white photos & videos  with our easy-to-use colorization tool",
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontFamily: "inter",
                      fontSize: 12,
                      color: secondarycolor,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: h * .06,
            ),
            items(
                text: "My Album",
                ic: Icons.photo_album_outlined,
                ontap: () {
                  Navigator.of(context).push(createRoute( MyAblum(isvideo: false,)));
                }),
            items(
                text: "Privacy Policy",
                ic: Icons.privacy_tip_outlined,
                ontap: () async {
                  if (Platform.isAndroid) {
                    launchUrl(Uri.parse(
                        "https://sites.google.com/view/cardashtranslator/home"));
                  } else if (Platform.isIOS) {
                    launchUrl(Uri.parse(
                        "https://sites.google.com/view/autoread/privacy"));
                  }
                }),
            Visibility(
              visible: Platform.isAndroid,
              child: items(
                  text: "More Apps",
                  ic: Icons.apps,
                  ontap: () async {
                    var url =
                        'https://play.google.com/store/apps/dev?id=4730059111577040107';
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
                  text: "Rate Us",
                  ic: Icons.thumb_up_alt_rounded,
                  ontap: () async {
                    var url =
                        'https://play.google.com/store/apps/details?id=com.appexsoft.autoread.cardashboard.translator';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                    }
                  }),
            ),
            items(
                text: "Feedback",
                ic: Icons.feedback_outlined,
                ontap: () {
                  if (Platform.isAndroid) {
                    launchUrl(Uri(
                      scheme: 'mailto',
                      path: 'appexsoft@gmail.com',
                      query: 'AutoRead',
                    ));
                  } else if (Platform.isIOS) {
                    launchUrl(Uri(
                      scheme: 'mailto',
                      path: 'skhastech@gmail.com',
                      query: 'AutoRead',
                    ));
                  }
                }),
            const Expanded(child: SizedBox()),
            Align(
              alignment: Alignment.bottomCenter,
              child: items(
                  text: "Exit",
                  ic: Icons.exit_to_app,
                  ontap: () {
                    ExitDialog(context);
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
