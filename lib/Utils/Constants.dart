////
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String indiaflag = "assets/flags/india.png";
String englangflag = "assets/flags/england.png";
String franceflag = "assets/flags/france.png";
String germanyflag = "assets/flags/germany.png";
String pakistanflag = "assets/flags/pakistan.png";
String portugalflag = "assets/flags/portugal.png";
String saudiarabiaflag = "assets/flags/saudi-arabia.png";
String spainflag = "assets/flags/spain.png";

Color primarycolor = const Color(0xffD0D0D0);
Color secondarycolor = Colors.black;
Color appbarcolor = const Color(0xff577C8D);
String imgartisticurl = "http://deoldify.khastechserver.tk/uploadImgArtistic";
String imgstableurl = "http://deoldify.khastechserver.tk/uploadImgStable";
String videocolorizerurl = "http://deoldify.khastechserver.tk/uploadVideo";
String CurrentLocale = 'en-Us';
User? user;
bool isopenadready=false;
bool istartadshown = false;
bool isbackadshown = false;
int clicks = 0;
var platforms = const MethodChannel('flutter.app/awake');

ShowSnackbar(
  BuildContext context,
  String text,
) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      padding: const EdgeInsets.symmetric(
          horizontal: 12.0, vertical: 12 // Inner padding for SnackBar content.
          ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.horizontal,
      content: Text(
        text,
        style: const TextStyle(fontFamily: "inter"),
      )));
}

Future sendAnalytics(FirebaseAnalytics analytics, String name) async {
  await analytics.logEvent(name: name, parameters: <String, dynamic>{});
}
