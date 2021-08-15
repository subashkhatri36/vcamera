import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController instance = Get.find();

  ///It take the screen width
  double swidth = 0.0;

  ///It take the screen height
  double sheight = 0.0;

  ///It checks that whether user screen is potrate or landscape
  RxBool islandscape = false.obs;

  ///This method return void
  ///It take context of current screen and help to calculate screen height and width
  void sizeinit(BuildContext context) {
    swidth = MediaQuery.of(context).size.width;
    sheight = MediaQuery.of(context).size.height;
    islandscape.value = swidth > 375 ? true : false;
  }

  @override
  void onInit() {
    super.onInit();
  }
}
