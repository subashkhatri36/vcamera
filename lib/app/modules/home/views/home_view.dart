import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vcamera/app/constant/constant.dart';
import 'package:vcamera/app/constant/controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    appController.sizeinit(context);
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Expanded(
          flex: appController.islandscape.value ? 3 : 5,
          child: Image.asset(AppImage.icon),
        ),
        Expanded(
            flex: appController.islandscape.value ? 6 : 3,
            child: Padding(
              padding: appController.islandscape.isTrue
                  ? EdgeInsets.symmetric(horizontal: appController.swidth * .2)
                  : EdgeInsets.symmetric(
                      horizontal: Constants.kDefaultPadding / 2),
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisSpacing: 2,
                crossAxisCount: 4,
                mainAxisSpacing: Constants.kDefaultPadding / 10,
                children: controller.menuList.toList(),
              ),
            )),
        SizedBox(
          height: appController.sheight * .1,
          child: Container(),
        )
      ],
    )));
  }
}
