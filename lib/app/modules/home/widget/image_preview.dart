import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vcamera/app/constant/controller.dart';
import 'package:vcamera/app/constant/enums.dart';
import 'package:vcamera/app/widget/buttons/custom_button.dart';

class ImagePreview extends StatelessWidget {
  final ImageType imagetype;
  final file;
  const ImagePreview({Key? key, required this.imagetype, required this.file})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imagetype == ImageType.Image
        ? Container(
            child: Column(
              children: [
                Expanded(
                    flex: 9,
                    child: Image.file(
                      File(hcontroller.imagePath),
                    )),
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
        : Container();
  }
}
