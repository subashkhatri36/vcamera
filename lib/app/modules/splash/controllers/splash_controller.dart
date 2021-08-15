import 'dart:async';

import 'package:get/get.dart';
import 'package:vcamera/app/modules/home/bindings/home_binding.dart';
import 'package:vcamera/app/modules/home/views/home_view.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  void loadpage() {
    Timer(Duration(seconds: 1), navigation);
  }

  void navigation() {
    Get.off(HomeView(), binding: HomeBinding());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
