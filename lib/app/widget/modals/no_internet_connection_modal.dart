import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vcamera/app/constant/constant.dart';
import 'package:vcamera/app/constant/controller.dart';

class NoInternetConnectionModal {
  NoInternetConnectionModal() {
    Get.dialog(
      AlertDialog(
        title: Text('No Internet Connection!'),
        content: Container(
          height: appController.islandscape.value
              ? appController.sheight * .3
              : appController.swidth * .3,
          child: Column(
            children: [
              Icon(
                Icons.wifi_off_outlined,
                size: Constants.kDefaultmargin * 2,
              ),
              SizedBox(
                height: Constants.kDefaultmargin / 2,
              ),
              Text(
                  'Please make sure you are connected to the internet and its working.'),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
