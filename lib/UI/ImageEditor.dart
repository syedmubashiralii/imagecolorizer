import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dioldifi/Controllers/SaveController.dart';
import 'package:dioldifi/UI/AlbumPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'dart:ui' as ui;
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../Utils/Constants.dart';
import '../Utils/SaveDialog.dart';

class ImageEditor extends StatefulWidget {
  var img;
  ImageEditor({Key? key, this.img}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
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
    return WillPopScope(
      onWillPop: () {
        EasyLoading.dismiss();
        return Future.value(true);
      },
      child: Container(
        color: appbarcolor,
        child: SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size(double.infinity, kToolbarHeight),
              child: ValueListenableBuilder<PainterControllerValue>(
                  valueListenable: controller,
                  child: Text(
                    "imageeditor".tr(),
                    style: const TextStyle(fontFamily: "trajan"),
                  ),
                  builder: (context, _, child) {
                    return Column(
                      children: [
                        AppBar(
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
                            IconButton(
                              icon: const Icon(
                                Icons.save,
                              ),
                              onPressed: () {
                                SomeDialog(
                                    appName: "appname".tr(),
                                    context: context,
                                    path: "assets/images/sparrow.png",
                                    mode: SomeMode.Asset,
                                    content: "saveimgdes".tr(),
                                    title: "saveimg".tr(),
                                    submit: () {
                                      renderAndDisplayImage();
                                    },
                                    buttonConfig: ButtonConfig(
                                      buttonCancelColor: Colors.red,
                                      buttonDoneColor: Colors.green,
                                      labelCancelColor: Colors.white,
                                      labelDoneColor: Colors.white,
                                    ));
                              },
                            ),
                          ],
                          elevation: 0,
                        ),
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
                        aspectRatio:
                            backgroundImage!.width / backgroundImage!.height,
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
                            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                          flex: 1, child: Text("Font Size")),
                                      Expanded(
                                        flex: 3,
                                        child: Slider.adaptive(
                                            min: 8,
                                            max: 96,
                                            value:
                                                controller.textStyle.fontSize ??
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
                                            value: HSVColor.fromColor(controller
                                                        .textStyle.color ??
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
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: w * .08),
                height: h * .12,
                width: w * .8,
                color: primarycolor,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/images/Group 248.png"),
                    Container(
                      height: h * .12,
                      width: w * .8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: addText,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 25.0, bottom: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    PhosphorIcons.textT,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  Text(
                                    "Text".tr(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: addframes,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, bottom: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    PhosphorIcons.frameCorners,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  Text(
                                    "Frame".tr(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: addSticker,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 22.0, bottom: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    PhosphorIcons.smileySticker,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  Text(
                                    "Sticker".tr(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
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
      EasyLoading.dismiss();
      return;
    } else {
      controller.addImage(
          await AssetImage(imageLink).image, const Size(100, 100));
      EasyLoading.dismiss();
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

  void setTextColor(double hue) {
    controller.textStyle = controller.textStyle
        .copyWith(color: HSVColor.fromAHSV(1, hue, 1, 1).toColor());
  }

  void selectShape(ShapeFactory? factory) {
    controller.shapeFactory = factory;
  }

  Future<void> renderAndDisplayImage() async {
    if (backgroundImage == null) return;
    final backgroundImageSize = Size(
        backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble());
    final imageFuture = await controller
        .renderImage(backgroundImageSize)
        .then<Uint8List?>((ui.Image image) => image.pngBytes);
    SaveController().saveImage(imageFuture);
    EasyLoading.showToast("Image saved Successfully");
    Navigator.pushReplacement(
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
                              return const Center(
                                  child: CircularProgressIndicator(
                                color: Colors.white,
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
                          await EasyLoading.show();
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
