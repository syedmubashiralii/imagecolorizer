import 'dart:developer';
import 'package:dioldifi/Utils/route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../UI/LandingPage.dart';
import 'Constants.dart';

void languagepickerdialog(BuildContext context) async {
  showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.white24,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 600),
      transitionBuilder: (BuildContext context, Animation<double> a1,
              Animation<double> a2, Widget child) =>
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(a1),
            child: Dialog(
              backgroundColor: const Color(0xffD0D0D0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "selectlang".tr(),
                            style: const TextStyle(
                              fontSize: 26,
                              fontFamily: "trajanbold",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for (int i = 0; i < list1.length; i++) ...[
                                InkWell(
                                  onTap: () {
                                    context.setLocale(list1[i]["locale"]);
                                    Navigator.of(context).pushReplacement(
                                        createRoute(LandingPage(
                                      locale: context.locale,
                                    )));
                                    log(list1[i]["name"].toString());
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: 40,
                                          width: 40,
                                          child:
                                              Image.asset(list1[i]["image"])),
                                      textwidget(list1[i]["name"])
                                    ],
                                  ),
                                ),
                              ]
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for (int i = 0; i < list2.length; i++) ...[
                                InkWell(
                                  onTap: () {
                                    context.setLocale(list2[i]["locale"]);
                                    Navigator.of(context).pushReplacement(
                                        createRoute(LandingPage(
                                      locale: context.locale,
                                    )));
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: 40,
                                          width: 40,
                                          child:
                                              Image.asset(list2[i]["image"])),
                                      textwidget(list2[i]["name"])
                                    ],
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
          ),
      pageBuilder: (context, anim1, anim2) {
        return Transform.rotate(
          angle: anim1.value,
        );
      });
}

Widget textwidget(String text) {
  return Text(
    text,
    style: const TextStyle(
        fontFamily: "inter",
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w400),
  );
}

List list1 = [
  {"name": "English", "image": englangflag, "locale": const Locale('en', 'US')},
  {"name": "हिंदी", "image": indiaflag, "locale": const Locale('hi', 'IN')},
  {"name": "Français", "image": franceflag, "locale": const Locale('fr', 'FR')},
  {"name": "اردو", "image": pakistanflag, "locale": const Locale('ur', 'PK')},
];
List list2 = [
  {"name": "Española", "image": spainflag, "locale": const Locale('es', 'ES')},
  {
    "name": "عربي",
    "image": saudiarabiaflag,
    "locale": const Locale('ar', 'AR')
  },
  {
    "name": "Português",
    "image": portugalflag,
    "locale": const Locale('pt', 'BR')
  },
  {"name": "Deutsch", "image": germanyflag, "locale": const Locale('de', 'DE')},
];
