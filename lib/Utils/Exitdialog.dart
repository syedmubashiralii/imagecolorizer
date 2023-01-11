import 'dart:io';
import 'package:dioldifi/Utils/Constants.dart';
import 'package:flutter/material.dart';

Future<bool> ExitDialog(BuildContext context) async {
  switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              color: appbarcolor,
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: const SizedBox(
                      height: 14,
                    ),
                    // child: const Icon(
                    //   Icons.exit_to_app,
                    //   size: 30,
                    //   color: Colors.white,
                    // ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Exit',
                        style: TextStyle(
                            fontFamily: "inter",
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.exit_to_app_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Are you Sure you want to exit.',
                    style: TextStyle(
                        fontFamily: "inter",
                        color: Colors.white70,
                        fontSize: 14),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 0);
              },
              child: Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.cancel,
                      color: appbarcolor,
                    ),
                  ),
                  Text(
                    'No',
                    style: TextStyle(fontFamily: "inter", color: appbarcolor),
                  )
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 1);
              },
              child: Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.check_circle,
                      color: appbarcolor,
                    ),
                  ),
                  Text(
                    'Yes',
                    style: TextStyle(fontFamily: "inter", color: appbarcolor),
                  )
                ],
              ),
            ),
          ],
        );
      })) {
    case 0:
      break;
    case 1:
      exit(0);
  }
  return false;
}

//network Sensitive
