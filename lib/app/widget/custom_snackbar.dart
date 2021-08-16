import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:vcamera/app/constant/theme_data.dart';

void customSnackbar(
        {String? title,
        required String message,
        IconData? leadingIcon,
        SnackPosition? snackPosition,
        Color? backgroundColor}) =>
    Get.showSnackbar(
      GetBar(
        onTap: (value) {
          Get.back();
        },
        snackPosition: snackPosition ?? SnackPosition.BOTTOM,
        duration: Duration(milliseconds: 3000),
        title: title ?? null,
        message: message,
        animationDuration: Duration(milliseconds: 1000),
        isDismissible: true,
        shouldIconPulse: true,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
        icon: Icon(leadingIcon ?? Icons.info_outline, color: Themes.WHITE),
        backgroundColor: backgroundColor ?? Themes.GREY,
      ),
    );
