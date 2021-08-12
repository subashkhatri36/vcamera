import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vcamera/app/modules/home/controllers/home_controller.dart';

class PotrateHomeCamera extends StatelessWidget {
  const PotrateHomeCamera({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FutureBuilder<void>(
          future: HomeController.homecontroller.initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return CameraPreview(
                  HomeController.homecontroller.cameraController);
            else
              return const Center(
                child: CircularProgressIndicator(),
              );
          })
    ]);
  }
}
