import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vcamera/app/constant/controller.dart';

class HomeController extends GetxController {
  static HomeController homecontroller = Get.find();
  late CameraController cameraController;
  late Future<void> initializeControllerFuture;
  int selectedCamera = 0;
  List<File> captureImages = [];

  @override
  void onInit() {
    initializeCamera(selectedCamera);
    super.onInit();
  }

  initializeCamera(int cameraIndex) async {
    cameraController = CameraController(
        appController.cameras[cameraIndex], ResolutionPreset.medium);
    initializeControllerFuture = cameraController.initialize();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    cameraController.dispose();
  }
}
