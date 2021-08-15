import 'package:get/get.dart';
import 'package:vcamera/app/core/controller/app_controller.dart';
import 'package:vcamera/app/modules/home/controllers/home_controller.dart';

import 'core/services/internet_connectivity/internet_connectivity.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController(), permanent: true);
    // Get.put(AdmobController(), permanent: true);
    Get.put(AppController(), permanent: true);
    Get.put(HomeController(), permanent: true);

    //t.lazyPut(() => QuestionssController(), fenix: true);
  }
}
