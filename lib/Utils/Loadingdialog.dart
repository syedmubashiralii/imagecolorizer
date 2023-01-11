import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'Constants.dart';

loadingdialog(BuildContext context) async {
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
                    child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "loadingdialogtext".tr(),
                        style: TextStyle(
                            fontFamily: "trajanbold",
                            color: appbarcolor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      LinearProgressIndicator(
                        minHeight: 6,
                        color: appbarcolor,
                        backgroundColor: primarycolor,
                      ),
                    ],
                  ),
                )),
              )));
}
