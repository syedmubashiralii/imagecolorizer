// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:dioldifi/UI/ImageEditor.dart';
import 'package:dioldifi/Utils/Constants.dart';
import 'package:dioldifi/Utils/SaveDialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Controllers/ApiController.dart';
import '../Controllers/ImagesController.dart';
import '../Utils/ImageCropper.dart';
import '../Utils/ImagePicker.dart';
import '../Utils/Loadingdialog.dart';
import '../Utils/check_connectivity.dart';
import '../Utils/route.dart';

class ImagePickerr extends StatefulWidget {
  String title;
  String url;
  ImagePickerr({super.key, required this.title, required this.url});

  @override
  State<ImagePickerr> createState() => _ImagePickerrState();
}

class _ImagePickerrState extends State<ImagePickerr> {
  bool isgallery = false;
  bool iscamera = true;
  List images = [];

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => getimages(),
    );
  }

  getimages() async {
    final applicationBloc =
        Provider.of<ImagesController>(context, listen: false);
    images = await applicationBloc.FetchImages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: primarycolor,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                Container(
                    height: h * .07,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    )),
                Container(
                  height: h * .068,
                  color: appbarcolor,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      SizedBox(
                        width: w * .02,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          // Navigator.of(context)
                          //     .push(createRoute(ImageEditor()));
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: w * .06,
                      ),
                      Text(
                        widget.title.tr().replaceAll("\n", " "),
                        style: const TextStyle(
                            fontFamily: "trajan",
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<ImagesController>(
                        builder: (context, value, child) {
                      return value.isloading == true
                          ? Center(
                              child: CircularProgressIndicator(
                                color: appbarcolor,
                                strokeWidth: 2,
                              ),
                            )
                          : value.isloading == false && images.isEmpty
                              ? Center(
                                  child: Text(
                                    "noimages".tr(),
                                    style: TextStyle(
                                        fontFamily: "trajanbold",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: appbarcolor),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: GridView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: images.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 3 / 4,
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 4,
                                            mainAxisSpacing: 4),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () async {
                                          if (await isDeviceConnected()) {
                                            var cpath = await imageCropperView(
                                                images[index]["path"]);
                                            if (cpath == "") {
                                            } else {
                                              loadingdialog(context);
                                              var uint =
                                                  await ImagesServerRequest(
                                                      File(cpath), widget.url);

                                              if (uint == null) {
                                                Navigator.pop(context);
                                                return;
                                              } else {
                                                Navigator.pop(context);
                                                Navigator.of(context).push(
                                                    createRoute(ImageEditor(
                                                  img: uint,
                                                )));
                                              }
                                            }
                                          } else {
                                            SomeDialog(
                                                appName: "Color Magic Pro",
                                                context: context,
                                                path:
                                                    "assets/images/sparrow.png",
                                                mode: SomeMode.Asset,
                                                content:
                                                    "Check Your intenet Connection and try again?",
                                                title: "No Internet Connection",
                                                submit: () {
                                                  Navigator.pop(context);
                                                },
                                                buttonConfig: ButtonConfig(
                                                  buttonCancelColor: Colors.red,
                                                  buttonDoneColor: Colors.green,
                                                  labelCancelColor:
                                                      Colors.white,
                                                  labelDoneColor: Colors.white,
                                                ));
                                          }
                                        },
                                        child: Image.file(
                                          File(images[index]["path"]),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                );
                    }),
                  ),
                ),
              ],
            )),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: w * .22),
            height: h * .12,
            width: w * .6,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                Image.asset(
                    // isgallery == false && iscamera == false
                    //   ?
                    "assets/images/gallerycamera.png"
                    // : iscamera
                    //     ? "assets/images/Group 240 (1).png"
                    //     : "assets/images/Group 240.png"
                    ),
                Container(
                  height: h * .12,
                  width: w * .6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          iscamera = true;
                          isgallery = false;
                          setState(() {});
                          ontap(ImageSource.camera);
                        },
                        onPanUpdate: (details) {
                          // Swiping in right direction.
                          if (details.delta.dx > 0) {
                            iscamera = false;
                            isgallery = true;
                            setState(() {});
                          }
                          // Swiping in left direction.
                          if (details.delta.dx < 0) {}
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.camera,
                                color: Colors.white,
                                size: 32,
                              ),
                              Text(
                                "camera".tr(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          iscamera = false;
                          isgallery = true;
                          setState(() {});
                          ontap(ImageSource.gallery);
                        },
                        onPanUpdate: (details) {
                          // Swiping in right direction.
                          if (details.delta.dx > 0) {}

                          // Swiping in left direction.
                          if (details.delta.dx < 0) {
                            iscamera = true;
                            isgallery = false;
                            setState(() {});
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.photo_album_outlined,
                                color: Colors.white,
                                size: 32,
                              ),
                              Text(
                                "gallery".tr(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ontap(ImageSource source) async {
    if (await isDeviceConnected()) {
      var path = await pickImage(source);
      if (path == '') {
      } else {
        var cpath = await imageCropperView(path);
        if (cpath == "") {
        } else {
          loadingdialog(context);
          var uint = await ImagesServerRequest(File(path), widget.url);
          log(uint.toString());
          if (uint == null) {
            Navigator.pop(context);
            return;
          } else {
            Navigator.pop(context);
            Navigator.of(context).push(createRoute(ImageEditor(
              img: uint,
            )));
          }
        }
      }
    } else {
      SomeDialog(
          appName: "Color Magic Pro",
          context: context,
          path: "assets/images/sparrow.png",
          mode: SomeMode.Asset,
          content: "Check Your intenet Connection and try again?",
          title: "No Internet Connection",
          submit: () {
            Navigator.pop(context);
          },
          buttonConfig: ButtonConfig(
            buttonCancelColor: Colors.red,
            buttonDoneColor: Colors.green,
            labelCancelColor: Colors.white,
            labelDoneColor: Colors.white,
          ));
    }
  }
}
