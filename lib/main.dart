import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:vcamera/app/constant/constant.dart';
import 'package:vcamera/app/constant/theme_data.dart';
import 'package:vcamera/app/inital_binding.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_NAME,
      theme: Themes.light,
      darkTheme: Themes.dark,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.native,
      builder: EasyLoading.init(),
      initialBinding: InitialBinding(),
    ),
  );
}
