import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:vcamera/app/constant/constant.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    controller.loadpage();
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Image.asset(AppImage.icon),
          ),
          Center(
            child: Text(
              APP_NAME,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
