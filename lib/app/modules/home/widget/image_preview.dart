import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vcamera/app/constant/constant.dart';
import 'package:vcamera/app/constant/controller.dart';
import 'dart:ui' as ui;
import 'package:vcamera/app/constant/enums.dart';
import 'package:vcamera/app/constant/theme_data.dart';
import 'package:vcamera/app/modules/home/widget/demo.dart';
import 'package:vcamera/app/utlis/filters.dart';
import 'package:vcamera/app/widget/buttons/custom_button.dart';

class ImagePreview extends StatefulWidget {
  final ImageType imagetype;
  final file;
  const ImagePreview({Key? key, required this.imagetype, required this.file})
      : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  final GlobalKey globalKey = GlobalKey();

  int mainIndex = -1;

  // void convertWidgetToImage() async {
  //   RenderRepaintBoundary repaintBoundary =
  //       globalKey.currentContext.findRenderObject();
  //   ui.Image boxImage = await repaintBoundary.toImage(pixelRatio: 1);
  //   ByteData byteData =
  //       await boxImage.toByteData(format: ui.ImageByteFormat.png);
  //   Uint8List uint8list = byteData.buffer.asUint8List();
  //   // Navigator.of(globalKey.currentContext).push(MaterialPageRoute(
  //   //     builder: (context) => CameraExampleHome()));
  // }

  @override
  Widget build(BuildContext context) {
    final Image image = Image.asset(
      AppImage.fliterImage,
      width: appController.swidth,
      fit: BoxFit.cover,
    );
    return Scaffold(
        backgroundColor: Themes.BLACK,
        body: SafeArea(
            child: widget.imagetype == ImageType.Image
                ? Container(
                    child: Column(
                      children: [
                        Expanded(
                            flex: 9,
                            child: RepaintBoundary(
                              key: globalKey,
                              child: mainIndex == -1
                                  ? Image.file(
                                      File(widget.file),
                                    )
                                  : ColorFiltered(
                                      colorFilter: ColorFilter.matrix(
                                          filters[mainIndex]),
                                      child: Image.file(
                                        File(widget.file),
                                      ),
                                    ),
                            )),
                        Container(
                          width: appController.swidth,
                          height: appController.swidth * .2,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    mainIndex = -1;
                                  });
                                },
                                child: Container(
                                  height: appController.swidth * .2,
                                  width: appController.swidth * .2,
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          Constants.kDefaultPadding / 4),
                                  child: Image.file(
                                    File(widget.file),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: filters.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            mainIndex = index;
                                          });
                                        },
                                        child: Container(
                                          height: appController.swidth * .2,
                                          width: appController.swidth * .2,
                                          margin: EdgeInsets.symmetric(
                                              horizontal:
                                                  Constants.kDefaultPadding /
                                                      4),
                                          child: ColorFiltered(
                                            colorFilter: ColorFilter.matrix(
                                                filters[index]),
                                            child: Image.file(
                                              File(widget.file),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomTextButton(
                                  label: 'Cancel',
                                  onpress: () {
                                    Get.back();
                                  },
                                ),
                              ),
                              Expanded(
                                child: CustomTextButton(
                                  label: 'Save',
                                  onpress: () {
                                    // GallerySaver.saveImage(file, albumName: 'vcamera')
                                    //     .then((bool? success) {});
                                    Get.back();
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : Container()));

/*
  
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_color_filters/filters.dart';
import 'dart:ui' as ui;

import 'package:flutter_color_filters/second_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _globalKey = GlobalKey();
  final List<List<double>> filters = [SEPIA_MATRIX, GREYSCALE_MATRIX , VINTAGE_MATRIX, SWEET_MATRIX];

  void convertWidgetToImage() async {
    RenderRepaintBoundary repaintBoundary = _globalKey.currentContext.findRenderObject();
    ui.Image boxImage = await repaintBoundary.toImage(pixelRatio: 1);
    ByteData byteData = await boxImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8list = byteData.buffer.asUint8List();
    Navigator.of(_globalKey.currentContext).push(MaterialPageRoute(
        builder: (context) => SecondScreen(
              imageData: uint8list,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Image image = Image.asset(
      "assets/images/sample.png",
      width: size.width,
      fit: BoxFit.cover,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Image Filters",
        ),
        backgroundColor: Colors.deepOrange,
        actions: [IconButton(icon: Icon(Icons.check), onPressed: convertWidgetToImage)],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: RepaintBoundary(
          key: _globalKey,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width,
              maxHeight: size.width,
            ),
            child: PageView.builder(
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  return ColorFiltered(
                    colorFilter: ColorFilter.matrix(filters[index]),
                    child: image,
                  );
                }),
          ),
        ),
      ),
    );
  }
}
Loading complete
                 */
  }
}
