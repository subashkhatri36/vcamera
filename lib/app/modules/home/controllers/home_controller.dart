import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vcamera/app/modules/home/widget/cat_dog_reco_widget.dart';
import 'package:vcamera/app/modules/home/widget/menu_items.dart';
import 'package:vcamera/app/modules/home/widget/save_gallary.dart';
import 'package:vcamera/app/widget/custom_snackbar.dart';

class HomeController extends GetxController {
  static HomeController homecontroller = Get.find();

  ///camera controller
  CameraController? controller;

  Future<void>? initializeControllerFuture;

  List<CameraDescription> cameras = [];

  bool isCameraInitialized = false;

//file to sore image
  XFile? imageFile;

  ///Exposure setting
  double minAvailableExposureOffSet = 0.0;
  double maxAvailableExposureOffset = 0.0;
  double currentExposureOffset = 0.0;

//working for flash
  late AnimationController flashModeControlRowAnimationController;
  late Animation<double> flashModeControlRowAnimation;
//exposure animation
  late AnimationController exposureModeControlRowAnimationController;
  late Animation<double> exposureModeControlRowAnimation;
//foused mode animation
  late AnimationController focusModeControlRowAnimationController;
  late Animation<double> focusModeControlRowAnimation;

  // bool enableAudio = false;

//zoom size
  double minAvailableZoom = 1.0;
  double maxAvailablezoom = 1.0;
  double currentScale = 1.0;
  double baseScale = 1.0;

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  ///counting pointers(number of user fingers on screen)
  int pointers = 0;

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
  RxBool isFrontCamera = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void onFlashModeButtonPressed() {
    if (flashModeControlRowAnimationController.value == 1) {
      flashModeControlRowAnimationController.reverse();
    } else {
      flashModeControlRowAnimationController.forward();
      exposureModeControlRowAnimationController.reverse();
    }
  }

  void onExposureModeButtonPressed() {
    if (exposureModeControlRowAnimationController.value == 1) {
      exposureModeControlRowAnimationController.reverse();
    } else {
      exposureModeControlRowAnimationController.forward();
      flashModeControlRowAnimationController.reverse();
      // _focusModeControlRowAnimationController.reverse();
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }
    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      print(e);
      customSnackbar(
          message: 'Cannot Appicable', snackPosition: SnackPosition.TOP);
      //rethrow;
    }
  }

  Future<void> setFocusMode(FocusMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFocusMode(mode);
    } on CameraException catch (e) {
      print(e);
      rethrow;
    }
  }

  void openVideo() async {}

  void openGallery() async {
    Get.to(SavedGallary());
  }

  void openScreenShot() {
    Get.to(CatDogRecognization());
  }

  void openLongScreenShot() {}
  void openPhotoEditing() {}
  void openVideoEditing() {}
  void openScreenReorder() {}

  ///Erro Log fro an message
  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  @override
  void onReady() {
    super.onReady();
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
