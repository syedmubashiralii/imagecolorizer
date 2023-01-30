import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constants.dart';

PermissionUsagedialog(BuildContext context) async {
  var h = MediaQuery.of(context).size.height;
  var w = MediaQuery.of(context).size.width;
  bool checkboxvalue = false;
  final prefs = await SharedPreferences.getInstance();
  showGeneralDialog(
      pageBuilder: (context, anim1, anim2) {
        return Transform.rotate(
          angle: anim1.value,
        );
      },
      barrierColor: Colors.white24,
      barrierDismissible: true,
      barrierLabel: "",
      context: context,
      transitionDuration: const Duration(milliseconds: 600),
      transitionBuilder: (BuildContext context, Animation<double> a1,
              Animation<double> a2, Widget child) =>
          StatefulBuilder(builder: (context, setstate) {
            return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -1),
                  end: Offset.zero,
                ).animate(a1),
                child: WillPopScope(
                  onWillPop: () async => true,
                  child: Dialog(
                    // insetPadding: EdgeInsets.all(40),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Permission Usage Description".tr(),
                            style: TextStyle(
                                fontFamily: "poppins",
                                color: appbarcolor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(CupertinoIcons.camera),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Text(
                                  "camerapermission".tr(),
                                  style: const TextStyle(
                                      fontSize: 16, fontFamily: "poppins"),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(CupertinoIcons.photo),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Text(
                                  "gallerypermission".tr(),
                                  style: const TextStyle(
                                      fontSize: 16, fontFamily: "poppins"),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: checkboxvalue,
                                onChanged: (bool? value) async {
                                  await prefs.setBool("dialog", value!);
                                  setstate(() {
                                    checkboxvalue = value;
                                  });
                                },
                              ),
                              Text(
                                "Do'nt Show Again".tr(),
                                style: const TextStyle(
                                    fontSize: 16, fontFamily: "poppins"),
                              ),
                              Spacer(),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("OK"))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          }));
}
