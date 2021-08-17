import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;
import 'package:vcamera/app/modules/home/widget/menu_items.dart';

class HomeController extends GetxController {
  static HomeController homecontroller = Get.find();

  late CameraController controller;
  String imagePath = '';
  late Future<void> initializeControllerFuture;
  bool isCameraInitialized = false;

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  ///Its the list of the menu Items that will be show in homescreen
  List<Widget> menuList = [
    MenuItems(
      iconData: Icons.camera,
      title: 'Camera',
      value: 1,
    ),
    MenuItems(
      iconData: Icons.videocam,
      title: 'Video',
      value: 2,
    ),
    MenuItems(
      iconData: Icons.photo,
      title: 'Gallery',
      value: 3,
    ),
    MenuItems(
      iconData: Icons.screenshot,
      title: 'ScreenShot',
      value: 4,
    ),
    MenuItems(
      iconData: Icons.screenshot,
      title: 'Long ScreenShot',
      value: 5,
    ),
    MenuItems(
      iconData: Icons.video_call,
      title: 'Screen Record',
      value: 6,
    ),
    MenuItems(
      iconData: Icons.wallpaper,
      title: 'Photo Edit',
      value: 7,
    ),
    MenuItems(
      iconData: Icons.center_focus_strong,
      title: 'video Edit',
      value: 7,
    ),
  ];

  RxBool isFlashOn = false.obs;
  RxBool isFrontCamera = false.obs;
  final icons = [
    Icon(
      Icons.car_rental,
      size: 50,
    ),
    Icon(
      Icons.car_repair,
      size: 50,
    ),
    Icon(
      Icons.card_membership,
      size: 50,
    ),
    Icon(
      Icons.bus_alert,
      size: 50,
    ),
    Icon(
      Icons.alternate_email,
      size: 50,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  void openVideo() async {}

  void openGallery() async {}

  void openScreenShot() {}
  void openLongScreenShot() {}
  void openPhotoEditing() {}
  void openVideoEditing() {}
  void openScreenReorder() {}

  @override
  void onReady() {
    super.onReady();
  }

  GlobalKey _globalKey = GlobalKey();
  void uploadImage(path) async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = path;
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());

      print(result);
    }
  }

  /// Returns a suitable camera icon for [direction].
  IconData getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
    }
  }

  @override
  void onClose() {}
}
