import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vcamera/app/constant/theme_data.dart';

/// custom app loader widget
class UIHelpers {
  /// show the loading modal. Default text: "Please wait..."
  static Future<void> showLoading({String? message}) async {
    // EasyLoading.instance..loadingStyle = EasyLoadingStyle.light;
    EasyLoading.show(
        // status: "Logging In...",
        dismissOnTap: false,
        indicator: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                backgroundColor: Themes.WHITE,
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Themes.PRIMARY_COLOR),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "${message ?? 'Please wait...'}",
                style: TextStyle(color: Themes.WHITE),
              )
            ],
          ),
        ));
  }

  /// closes loader
  static void dismiss() {
    EasyLoading.dismiss();
  }

  /// show toast message. Does not display if provided empty string
  static void showToast(String? message) {
    EasyLoading.instance..loadingStyle = EasyLoadingStyle.dark;
    EasyLoading.showToast(
      "${message ?? ''}",
      toastPosition: EasyLoadingToastPosition.top,
    );
  }
}
