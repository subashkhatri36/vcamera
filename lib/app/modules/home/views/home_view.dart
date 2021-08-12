import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:vcamera/app/constant/controller.dart';
import 'package:vcamera/app/modules/home/widget/landscape_home.dart';
import 'package:vcamera/app/modules/home/widget/potrate_home.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    appController.sizeinit(context);
    return Scaffold(
        body: Obx(() => appController.islandscape.value
            ? LandScapeHomeCamera()
            : PotrateHomeCamera()));
  }
}
