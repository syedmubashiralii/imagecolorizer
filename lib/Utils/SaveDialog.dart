import 'dart:io';

import 'package:dioldifi/Utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum SomeMode { Lottie, Network, Asset }

class ButtonConfig {
  final String dialogDone, dialogCancel;
  Color buttonCancelColor, buttonDoneColor, labelCancelColor, labelDoneColor;

  ButtonConfig(
      {this.dialogDone = 'Done',
      required this.labelCancelColor,
      required this.labelDoneColor,
      this.dialogCancel = 'Cancel',
      required this.buttonCancelColor,
      required this.buttonDoneColor}) {
    if (buttonCancelColor == null) buttonCancelColor = const Color(0xffF4F4F8);
    if (buttonDoneColor == null) buttonDoneColor = const Color(0xff5841BF);
    if (labelCancelColor == null) labelCancelColor = Colors.black;
    if (labelDoneColor == null) labelDoneColor = Colors.white;
  }
}

class SomeDialog {
  final String path;
  final String title;
  final String content;
  final double dialogHeight;
  final double imageHeight;
  final double imageWidth;
  final Function submit;
  final BuildContext context;
  String appName;
  ButtonConfig buttonConfig;
  SomeMode mode = SomeMode.Lottie;

  SomeDialog(
      {Key? key,
      required this.context,
      required this.path,
      required this.title,
      required this.content,
      required this.submit,
      required this.mode,
      required this.buttonConfig,
      this.imageHeight = 150,
      this.imageWidth = 150,
      this.dialogHeight = 310,
      this.appName = "SomeDialog"}) {
    showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Transform.rotate(
            angle: anim1.value,
          );
        },
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
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      contentPadding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      content: Container(
                        width: double.maxFinite,
                        height: dialogHeight,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 16),
                            if (mode == SomeMode.Lottie) ...[
                              Center(
                                child: Lottie.asset(
                                  "$path",
                                  width: imageWidth,
                                  height: imageHeight,
                                ),
                              ),
                            ] else if (mode == SomeMode.Asset) ...[
                              Center(
                                child: Image.asset(
                                  "$path",
                                  width: imageWidth,
                                  height: imageHeight,
                                ),
                              ),
                            ] else ...[
                              Center(
                                child: Image.network(path),
                              )
                            ],
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              '$title',
                              style: TextStyle(
                                fontFamily: "poppins",
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: appbarcolor,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              '$content',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "poppins",
                                color: appbarcolor,
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: FractionalOffset.bottomCenter,
                                child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(
                                            '$appName',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontFamily: "poppins",
                                              fontWeight: FontWeight.w700,
                                              color: appbarcolor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 22),
                                                  decoration: BoxDecoration(
                                                      color: buttonConfig
                                                          .buttonCancelColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16)),
                                                  child: Text(
                                                    "${buttonConfig.dialogCancel}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily: "poppins",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: buttonConfig
                                                          .labelCancelColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  submit();
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 26),
                                                  decoration: BoxDecoration(
                                                      color: buttonConfig
                                                          .buttonDoneColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16)),
                                                  child: Text(
                                                    "${buttonConfig.dialogDone}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily: "poppins",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: buttonConfig
                                                          .labelDoneColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )));
  }
}
