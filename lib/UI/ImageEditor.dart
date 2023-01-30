// ignore_for_file: use_build_context_synchronously, library_prefixes, depend_on_referenced_packages

import 'dart:convert';
import 'package:dioldifi/UI/PhotoFilters.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart' as p;
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dioldifi/Controllers/SaveController.dart';
import 'package:dioldifi/UI/AlbumPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image/image.dart' as imageLib;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../Controllers/Ads_Controller.dart';
import '../Controllers/CoinsController.dart';
import '../Controllers/LoginSignUpController.dart';
import '../Utils/Constants.dart';
import '../Utils/InApp.dart';
import '../Utils/preset_filters.dart';

class ImageEditor extends StatefulWidget {
  Uint8List img;
  int coin;
  ImageEditor({Key? key, required this.img, required this.coin})
      : super(key: key);

  @override
  _ImageEditorState createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  static const Color red = Color(0xFFFF0000);
  FocusNode textFocusNode = FocusNode();
  late PainterController controller;
  ui.Image? backgroundImage;
  Paint shapePaint = Paint()
    ..strokeWidth = 5
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  List<String> imageLinks = [];
  List<String> frameslist = [];
  String stickerjson =
      "http://134.209.195.127/api/index.php?all=yes&keys=one_click_two_cut/1C2C_Stickers_2105";

  getstickers() async {
    try {
      for (int i = 0; i < 17; i++) {
        frameslist.add("assets/frames/$i.png");
      }
      var url = Uri.parse(stickerjson);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        for (var item in parsed) {
          imageLinks.add("http://134.209.195.127${item["thumbnail_link"]}");
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  getads() {
    final ads = Provider.of<GetAds>(context, listen: false);
    ads.EditorPageBanner();
    if (ads.backint == null) {
      ads.createBackInterstitialad();
    }
    if (ads.albumint == null) {
      ads.Createalbuminiterstitial();
    }
    if (ads.editorint == null) {
      ads.createeditorint();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Provider.of<coinsController>(context, listen: false).isadfree ==
          false) {
        getads();
      }
    });
    controller = PainterController(
        settings: PainterSettings(
            text: TextSettings(
              focusNode: textFocusNode,
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: red,
                  fontSize: 18,
                  fontFamily: "poppins"),
            ),
            freeStyle: const FreeStyleSettings(
              color: red,
              strokeWidth: 5,
            ),
            shape: ShapeSettings(
              paint: shapePaint,
            ),
            scale: const ScaleSettings(
              enabled: true,
              minScale: 1,
              maxScale: 5,
            )));
    getstickers();
    textFocusNode.addListener(onFocus);
    initBackground();
  }

  /// Fetches image from an [ImageProvider] (in this example, [NetworkImage])
  /// to use it as a background
  void initBackground() async {
    var image = await MemoryImage(widget.img).image;
    //var image = await const AssetImage("assets/images/sparrow.png").image;
    setState(() {
      backgroundImage = image;
      controller.background = image.backgroundDrawable;
    });
  }

  void onFocus() {
    setState(() {});
  }

  Widget buildDefault(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final ads = Provider.of<GetAds>(context);
    return WillPopScope(
      onWillPop: () {
        EasyLoading.dismiss();
        if (Provider.of<coinsController>(context, listen: false).isadfree ==
            false) {
          ads.showbackinterstitial();
        }
        return Future.value(true);
      },
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Container(
          color: appbarcolor,
          child: SafeArea(
            child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size(double.infinity, h * .18),
                  child: ValueListenableBuilder<PainterControllerValue>(
                      valueListenable: controller,
                      child: Text(
                        "imageeditor".tr(),
                        style: const TextStyle(
                            fontFamily: "trajan",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                      builder: (context, _, child) {
                        return Column(
                          children: [
                            Provider.of<coinsController>(
                                      context,
                                    ).isadfree ==
                                    true
                                ? SizedBox(
                                    height: 0,
                                  )
                                : Container(
                                    height: ads.iseditorpagebannerloaded
                                        ? h * .07
                                        : h * 0.03,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    child: ads.iseditorpagebannerloaded
                                        ? AdWidget(ad: ads.editorpage)
                                        : const Center(
                                            child: Text("Advertisment"),
                                          )),
                            AppBar(
                              leading: IconButton(
                                  onPressed: () {
                                    if (Provider.of<coinsController>(context,
                                                listen: false)
                                            .isadfree ==
                                        false) {
                                      ads.showbackinterstitial();
                                    }
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  )),
                              backgroundColor: appbarcolor,
                              title: child,
                              actions: [
                                // Delete the selected drawable
                                IconButton(
                                  icon: const Icon(
                                    PhosphorIcons.trash,
                                  ),
                                  onPressed:
                                      controller.selectedObjectDrawable == null
                                          ? null
                                          : removeSelectedDrawable,
                                ),
                                // Container(
                                //   margin:
                                //       const EdgeInsets.symmetric(vertical: 8),
                                //   alignment: Alignment.center,
                                //   decoration: BoxDecoration(
                                //       shape: BoxShape.circle,
                                //       border: Border.all(color: Colors.white)),
                                //   child: IconButton(
                                //     icon: const Icon(
                                //       Icons.share,
                                //       color: Colors.white,
                                //     ),
                                //     onPressed: () {},
                                //   ),
                                // ),
                                Consumer<coinsController>(
                                    builder: (context, coindata, child) {
                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.save,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        if (coindata.totalcoins < widget.coin) {
                                          EasyLoading.showToast(
                                              "You have'nt enough coins please purchase coins to save your picture",
                                              duration: Duration(seconds: 2));
                                          Future.delayed(Duration(seconds: 1),
                                              () {
                                            showCupertinoModalBottomSheet(
                                                expand: false,
                                                context: context,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (context) => Container(
                                                    height: h * .4,
                                                    child: inApp()));
                                          });
                                        } else {
                                          EasyLoading.show();
                                          coindata.totalcoins -= widget.coin;
                                          await LoginSignup()
                                              .UpdateCoins(coindata.totalcoins,
                                                  context, user!.email!)
                                              .then((value) =>
                                                  coindata.updatecoins());

                                          if (coindata.isadfree == false) {
                                            ads.showalbumint();
                                          }
                                          renderAndDisplayImage();
                                        }
                                      },
                                    ),
                                  );
                                }),
                              ],
                              elevation: 0,
                            ),
                            // Stack(
                            //   children: [
                            //     Container(
                            //       height: h * .01,
                            //       color: appbarcolor,
                            //     ),
                            //     SizedBox(
                            //       width: double.infinity,
                            //       child: Image.asset(
                            //           "assets/images/appbarbottom.png"),
                            //     ),
                            //   ],
                            // ),
                          ],
                        );
                      }),
                ),
                backgroundColor: primarycolor,
                body: Stack(
                  children: [
                    if (backgroundImage != null)
                      Positioned.fill(
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: backgroundImage!.width /
                                backgroundImage!.height,
                            child: FlutterPainter(
                              controller: controller,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: ValueListenableBuilder(
                        valueListenable: controller,
                        builder: (context, _, __) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 400,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (textFocusNode.hasFocus) ...[
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            FocusManager.instance.primaryFocus!
                                                .unfocus();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    appbarcolor),
                                          ),
                                          child: const Text("Done"),
                                        ),
                                      ),
                                      // Control text font size
                                      Row(
                                        children: [
                                          const Expanded(
                                              flex: 1,
                                              child: Text("Font Size")),
                                          Expanded(
                                            flex: 3,
                                            child: Slider.adaptive(
                                                min: 8,
                                                max: 96,
                                                value: controller
                                                        .textStyle.fontSize ??
                                                    14,
                                                onChanged: setTextFontSize),
                                          ),
                                        ],
                                      ),

                                      // Control text color hue
                                      Row(
                                        children: [
                                          const Expanded(
                                              flex: 1, child: Text("Color")),
                                          Expanded(
                                            flex: 3,
                                            child: Slider.adaptive(
                                                min: 0,
                                                max: 359.99,
                                                value: HSVColor.fromColor(
                                                        controller.textStyle
                                                                .color ??
                                                            red)
                                                    .hue,
                                                activeColor:
                                                    controller.textStyle.color,
                                                onChanged: setTextColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (context, _, __) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: h * .08,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                              color: appbarcolor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    String filename = '';
                                    final directory =
                                        await getApplicationDocumentsDirectory();
                                    var imageFile = await File(
                                            '${directory.path}/filters.png')
                                        .create();
                                    await imageFile.writeAsBytes(widget.img);
                                    filename = p.basename(imageFile.path);
                                    var image = imageLib.decodeImage(
                                        imageFile.readAsBytesSync());
                                    image =
                                        imageLib.copyResize(image!, width: 600);
                                    Map? imagefile = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PhotoFilterSelector(
                                          title: const Text(
                                            "Photo Filters",
                                            style: TextStyle(
                                                fontFamily: "trajan",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          image: image!,
                                          appBarColor: appbarcolor,
                                          filters: presetFiltersList,
                                          filename: filename,
                                          loader: const Center(
                                              child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          )),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                    if (imagefile == null) {
                                    } else {
                                      if (imagefile
                                          .containsKey('image_filtered')) {
                                        imageFile = imagefile['image_filtered'];
                                        widget.img =
                                            await imageFile.readAsBytesSync();
                                        initBackground();
                                        print(imageFile.path);
                                      }
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: h * .04,
                                          width: h * .05,
                                          child: const Icon(
                                            Icons.filter,
                                            color: Colors.white,
                                          )),
                                      const Text("Filter",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: "poppins"))
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    addframes();
                                    clicks++;
                                    if (clicks % 2 == 0) {
                                      ads.showeditorint();
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: h * .04,
                                          width: h * .05,
                                          child: const Icon(
                                            PhosphorIcons.frameCorners,
                                            color: Colors.white,
                                          )),
                                      const Text("Frame",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: "poppins"))
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    addText();
                                    clicks++;
                                    if (clicks % 2 == 0) {
                                      ads.showeditorint();
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: h * .04,
                                          width: h * .05,
                                          child: const Icon(
                                            PhosphorIcons.textAa,
                                            color: Colors.white,
                                          )),
                                      const Text("Text",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: "poppins"))
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    addSticker();
                                    clicks++;
                                    if (clicks % 2 == 0) {
                                      ads.showeditorint();
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: h * .04,
                                          width: h * .05,
                                          child: const Icon(
                                            PhosphorIcons.smileySticker,
                                            color: Colors.white,
                                          )),
                                      const Text("Sticker",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: "poppins"))
                                    ],
                                  ),
                                ),

                                // Free-style drawing
                              ],
                            ),
                          ),
                        ))),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildDefault(context);
  }

  void undo() {
    controller.undo();
  }

  void redo() {
    controller.redo();
  }

  void toggleFreeStyleDraw() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.draw
        ? FreeStyleMode.draw
        : FreeStyleMode.none;
  }

  void toggleFreeStyleErase() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.erase
        ? FreeStyleMode.erase
        : FreeStyleMode.none;
  }

  void addText() {
    if (controller.freeStyleMode != FreeStyleMode.none) {
      controller.freeStyleMode = FreeStyleMode.none;
    }
    controller.addText();
  }

  void addSticker() async {
    final imageLink = await showDialog<String>(
        context: context,
        builder: (context) => SelectStickerImageDialog(
              imagesLinks: imageLinks,
            ));
    if (imageLink == null) {
      EasyLoading.dismiss();
      return;
    } else {
      controller.addImage(
          await NetworkImage(imageLink).image, const Size(100, 100));
      EasyLoading.dismiss();
    }
  }

  void addframes() async {
    final imageLink = await showDialog<String>(
        context: context,
        builder: (context) => SelectFrameImageDialog(
              imagesLinks: frameslist,
            ));
    if (imageLink == null) {
      return;
    } else {
      controller.addImage(
          await AssetImage(imageLink).image, const Size(100, 100));
      // SomeDialog(
      //     appName: "appname".tr(),
      //     context: context,
      //     path: "assets/images/sparrow.png",
      //     mode: SomeMode.Asset,
      //     content: "addframedes".tr(),
      //     title: "addframe".tr(),
      //     submit: () async {
      //       controller.addImage(
      //           await AssetImage(imageLink).image, const Size(100, 100));
      //       var path = await pickImage(ImageSource.gallery);
      //       if (path == '') {
      //       } else {
      //         var cpath = await imageCropperView(path);
      //         if (cpath == "") {
      //         } else {
      //           controller.addImage(
      //               await FileImage(File(cpath)).image, const Size(100, 100));
      //         }
      //       }
      //     },
      //     cancel: () async {
      //     },
      //     buttonConfig: ButtonConfig(
      //       buttonCancelColor: Colors.red,
      //       buttonDoneColor: Colors.green,
      //       labelCancelColor: Colors.white,
      //       labelDoneColor: Colors.white,
      //     ));
    }
  }

  void setFreeStyleStrokeWidth(double value) {
    controller.freeStyleStrokeWidth = value;
  }

  void setFreeStyleColor(double hue) {
    controller.freeStyleColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
  }

  void setTextFontSize(double size) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.textSettings = controller.textSettings.copyWith(
          textStyle:
              controller.textSettings.textStyle.copyWith(fontSize: size));
    });
  }

  void setShapeFactoryPaint(Paint paint) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.shapePaint = paint;
    });
  }

  setTextColor(double hue) {
    controller.textStyle = controller.textStyle
        .copyWith(color: HSVColor.fromAHSV(1, hue, 1, 1).toColor());
  }

  void selectShape(ShapeFactory? factory) {
    controller.shapeFactory = factory;
  }

  Future<void> renderAndDisplayImage() async {
    if (backgroundImage == null) {
      EasyLoading.dismiss();
      return;
    }

    final backgroundImageSize = Size(
        backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble());
    final imageFuture = await controller
        .renderImage(backgroundImageSize)
        .then<Uint8List?>((ui.Image image) => image.pngBytes);
    SaveController().saveImage(imageFuture);
    EasyLoading.showToast("Image saved Successfully");
    EasyLoading.dismiss();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyAblum(
                  isvideo: false,
                )));
  }

  void removeSelectedDrawable() {
    final selectedDrawable = controller.selectedObjectDrawable;
    if (selectedDrawable != null) controller.removeDrawable(selectedDrawable);
  }

  void flipSelectedImageDrawable() {
    final imageDrawable = controller.selectedObjectDrawable;
    if (imageDrawable is! ImageDrawable) return;

    controller.replaceDrawable(
        imageDrawable, imageDrawable.copyWith(flipped: !imageDrawable.flipped));
  }
}

class RenderedImageDialog extends StatelessWidget {
  final Future<Uint8List?> imageFuture;

  const RenderedImageDialog({Key? key, required this.imageFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rendered Image"),
      content: FutureBuilder<Uint8List?>(
        future: imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox();
          }
          return InteractiveViewer(
              maxScale: 10, child: Image.memory(snapshot.data!));
        },
      ),
    );
  }
}

class SelectStickerImageDialog extends StatelessWidget {
  final List<String> imagesLinks;

  const SelectStickerImageDialog({Key? key, this.imagesLinks = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Select sticker",
          style: TextStyle(fontFamily: "poppins", color: appbarcolor)),
      content: imagesLinks.isEmpty
          ? const Text("No Stickers Loaded!")
          : FractionallySizedBox(
              heightFactor: 0.5,
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    for (final imageLink in imagesLinks)
                      InkWell(
                        onTap: () async {
                          await EasyLoading.show();
                          Navigator.pop(context, imageLink);
                        },
                        child: FractionallySizedBox(
                          widthFactor: 1 / 4,
                          child: CachedNetworkImage(
                            imageUrl: imageLink,
                            placeholder: (context, url) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: appbarcolor,
                                strokeWidth: 2,
                              ));
                            },
                            errorWidget: (context, url, error) {
                              return const Icon(Icons.error);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          child: Text(
            "Cancel",
            style: TextStyle(fontFamily: "poppins", color: appbarcolor),
          ),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}

class SelectFrameImageDialog extends StatelessWidget {
  final List<String> imagesLinks;

  const SelectFrameImageDialog({Key? key, this.imagesLinks = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Select Frame",
          style: TextStyle(fontFamily: "poppins", color: appbarcolor)),
      content: imagesLinks.isEmpty
          ? const Text("No Frame Loaded!")
          : FractionallySizedBox(
              heightFactor: 0.5,
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    for (final imageLink in imagesLinks)
                      InkWell(
                        onTap: () async {
                          Navigator.pop(context, imageLink);
                        },
                        child: FractionallySizedBox(
                          widthFactor: 1 / 4,
                          child: Image.asset(imageLink),
                        ),
                      ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          child: Text(
            "Cancel",
            style: TextStyle(fontFamily: "poppins", color: appbarcolor),
          ),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}





//old bottom


   // bottomNavigationBar: Padding(
              //   padding: const EdgeInsets.only(bottom: 8.0),
              //   child: Container(
              //     margin: EdgeInsets.symmetric(horizontal: w * .08),
              //     height: h * .12,
              //     width: w * .8,
              //     color: primarycolor,
              //     child: Stack(
              //       fit: StackFit.expand,
              //       alignment: Alignment.center,
              //       children: [
              //         Image.asset("assets/images/editortoffee.png"),
              //         Container(
              //           height: h * .12,
              //           width: w * .8,
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               GestureDetector(
              //                 onTap: () {
              //                   addText();
              //                   clicks++;
              //                   if (clicks % 2 == 0) {
              //                     ads.showeditorint();
              //                   }
              //                 },
              //                 child: Padding(
              //                   padding: const EdgeInsets.only(
              //                       left: 25.0, bottom: 5),
              //                   child: Column(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     crossAxisAlignment: CrossAxisAlignment.center,
              //                     children: [
              //                       const Icon(
              //                         PhosphorIcons.textT,
              //                         color: Colors.white,
              //                         size: 24,
              //                       ),
              //                       Text(
              //                         "Text".tr(),
              //                         style: const TextStyle(
              //                             color: Colors.white, fontSize: 15),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //               const Spacer(),
              //               GestureDetector(
              //                 onTap: () {
              //                   addframes();
              //                   clicks++;
              //                   if (clicks % 2 == 0) {
              //                     ads.showeditorint();
              //                   }
              //                 },
              //                 child: Padding(
              //                   padding: const EdgeInsets.only(
              //                       left: 15.0, bottom: 5),
              //                   child: Column(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     crossAxisAlignment: CrossAxisAlignment.center,
              //                     children: [
              //                       const Icon(
              //                         PhosphorIcons.frameCorners,
              //                         color: Colors.white,
              //                         size: 24,
              //                       ),
              //                       Text(
              //                         "Frame".tr(),
              //                         style: const TextStyle(
              //                             color: Colors.white, fontSize: 15),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //               const Spacer(),
              //               GestureDetector(
              //                 onTap: () {
              //                   addSticker();
              //                   clicks++;
              //                   if (clicks % 2 == 0) {
              //                     ads.showeditorint();
              //                   }
              //                 },
              //                 child: Padding(
              //                   padding: const EdgeInsets.only(
              //                       right: 22.0, bottom: 5),
              //                   child: Column(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     crossAxisAlignment: CrossAxisAlignment.center,
              //                     children: [
              //                       const Icon(
              //                         PhosphorIcons.smileySticker,
              //                         color: Colors.white,
              //                         size: 24,
              //                       ),
              //                       Text(
              //                         "Sticker".tr(),
              //                         style: const TextStyle(
              //                             color: Colors.white, fontSize: 15),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),