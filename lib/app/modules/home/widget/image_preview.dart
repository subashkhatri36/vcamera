import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vcamera/app/constant/constant.dart';
import 'package:vcamera/app/constant/controller.dart';
import 'package:vcamera/app/constant/enums.dart';
import 'package:vcamera/app/constant/theme_data.dart';
import 'package:vcamera/app/modules/home/widget/save_gallary.dart';
import 'package:vcamera/app/widget/buttons/custom_button.dart';
import 'dart:ui' as ui;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.photo),
              onPressed: () {
                Get.to(() => SavedGallary());
              },
            )
          ],
        ),
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
                                    capturePng();
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
  }

  Future<void> capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary? boundary = globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      //String bs64 = base64Encode(pngBytes);
      appController.imagesFiles.add(pngBytes);
      appController.saveintoDatabase();
      //return pngBytes;
    } catch (e) {
      print(e);
    }
  }
}
