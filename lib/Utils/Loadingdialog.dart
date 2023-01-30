import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'Constants.dart';

loadingdialog(BuildContext context) async {
  var w = MediaQuery.of(context).size.width;
  var h = MediaQuery.of(context).size.height;
  showGeneralDialog(
      pageBuilder: (context, anim1, anim2) {
        return Transform.rotate(
          angle: anim1.value,
        );
      },
      barrierColor: Colors.white24,
      context: context,
      transitionDuration: const Duration(milliseconds: 600),
      transitionBuilder: (BuildContext context, Animation<double> a1,
              Animation<double> a2, Widget child) =>
          SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(a1),
              child: WillPopScope(
                onWillPop: () async => false,
                child: Dialog(
                    backgroundColor: const Color(0xffcccccc),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "loadingdialogtext".tr(),
                            style: const TextStyle(
                                fontFamily: "trajanbold",
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                              height: h * .3,
                              width: w * .5,
                              child: Image.asset(
                                "assets/images/pngegg-(5)-modified-Recovered.gif",
                                fit: BoxFit.contain,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          LinearProgressIndicator(
                            minHeight: 6,
                            color: appbarcolor,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            height: h * .2,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () async {},
                                  child: Container(
                                    height: h * .2,
                                    width: w * .45,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/button1.png"))),
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
                                  onTap: () async {},
                                  child: Container(
                                    height: h * .2,
                                    alignment: Alignment.center,
                                    width: w * .45,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/button2.png"))),
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
                        ],
                      ),
                    )),
              )));
}
