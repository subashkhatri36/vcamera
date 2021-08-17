import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:vcamera/app/constant/controller.dart';
import 'package:vcamera/app/constant/enums.dart';
import 'package:vcamera/app/constant/theme_data.dart';
import 'package:vcamera/app/modules/home/widget/image_preview.dart';
import 'package:vcamera/app/widget/custom_snackbar.dart';

List<CameraDescription> cameras = [];
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MainCamera extends StatefulWidget {
  @override
  _MainCameraState createState() {
    return _MainCameraState();
  }
}

class _MainCameraState extends State<MainCamera> with WidgetsBindingObserver {
  // final hController = Get.put(CameraPreviewController());

  @override
  void initState() {
    super.initState();
    setCameras();

    WidgetsBinding.instance!.addObserver(this);
  }

  Future<void> setCameras() async {
    cameras = await availableCameras();
    hcontroller.controller =
        CameraController(cameras[0], ResolutionPreset.medium);
    hcontroller.controller.initialize().then((_) {
      hcontroller.initializeControllerFuture =
          hcontroller.controller.initialize();
      if (!mounted) {
        return;
      }
      hcontroller.isCameraInitialized = true;
      //imagePath='';
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      hcontroller.controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (hcontroller.controller.description.name.isNotEmpty) {
        onNewCameraSelected(hcontroller.controller.description);
      }
    }
  }

  void toggleCamera([int index = 0]) async {
    hcontroller.controller = CameraController(
      cameras[index],
      ResolutionPreset.medium,
    );

    // If the controller is updated then update the UI.
    hcontroller.controller.addListener(() {
      if (mounted) setState(() {});
      if (hcontroller.controller.value.hasError) {
        customSnackbar(
            title: "",
            message:
                'Camera error ${hcontroller.controller.value.errorDescription}');
      }
    });

    try {
      await hcontroller.controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    appController.sizeinit(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Stack(
                  children: [
                    _cameraPreviewWidget(),
                    Positioned(
                      top: 40,
                      left: 30,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Themes.GREY,
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 25,
                          ),
                          onPressed: () =>
                              Get.back(result: hcontroller.imagePath),
                        ),
                      ),
                    ),
                    Obx(() => Positioned(
                        top: appController.islandscape.value
                            ? null
                            : appController.sheight * .05,
                        right: appController.islandscape.value ? null : 10,
                        bottom: appController.islandscape.value
                            ? appController.sheight * .05
                            : null,
                        left: appController.islandscape.value ? 10 : 0,
                        child: _thumbnailWidget()))
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (hcontroller.isCameraInitialized) {
      return Stack(
        children: [
          // Center(child: CameraPreview(controller)),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CameraPreview(hcontroller.controller),
          ),
          //swiper(),
          Padding(
            padding: appController.islandscape.value
                ? const EdgeInsets.only(right: 10)
                : EdgeInsets.only(bottom: 10),
            child: cameraButtons(),
          ),
        ],
      );
    } else {
      return Center(
          child:
              CircularProgressIndicator()); // Otherwise, display a loading indicator.
    }
  }

  Widget swiper() {
    return Center(
        // child: Swiper(
        //     itemCount: hController.icons.length,
        //     itemBuilder: (context, index) {
        //       return hController.icons[index];
        //     }),
        );
  }

  Widget cameraButtons() {
    return Padding(
      padding: EdgeInsets.only(
          bottom: appController.islandscape.value
              ? appController.swidth * .004
              : (appController.sheight * 0.04)),
      child: Obx(
        () => Align(
            alignment: appController.islandscape.value
                ? Alignment.centerRight
                : Alignment.bottomCenter,
            child: appController.islandscape.value
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Obx(() {
                          return hcontroller.isFlashOn.isTrue
                              ? IconButton(
                                  color: Themes.WHITE,
                                  icon: Icon(
                                    Icons.flash_off_outlined,
                                    size: (appController.swidth * 0.045),
                                  ),
                                  onPressed: () {
                                    // controller.setFlashMode(FlashMode.off);
                                    hcontroller.isFlashOn.value = false;
                                  })
                              : IconButton(
                                  color: Themes.WHITE,
                                  icon: Icon(
                                    Icons.flash_on_outlined,
                                    size: (appController.swidth * 0.045),
                                  ),
                                  onPressed: () {
                                    // controller.setFlashMode(FlashMode.always);
                                    hcontroller.isFlashOn.value = true;
                                  });
                        }),
                        SizedBox(
                          height: appController.swidth * 0.029,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: GestureDetector(
                            onTap: hcontroller.controller.value.isInitialized &&
                                    !hcontroller
                                        .controller.value.isRecordingVideo
                                ? onTakePictureButtonPressed
                                : null,
                            child: Container(
                              height: (appController.swidth * 0.075),
                              width: (appController.swidth * 0.075),
                              color: Themes.GREY50,
                              child: Icon(Icons.camera),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: appController.swidth * 0.029,
                        ),
                        Obx(() {
                          return hcontroller.isFrontCamera.isTrue
                              ? IconButton(
                                  color: Themes.WHITE,
                                  icon: Icon(
                                    Icons.flip_camera_ios_rounded,
                                    size: (appController.swidth * 0.045),
                                  ),
                                  onPressed: () {
                                    toggleCamera(0);
                                    hcontroller.isFrontCamera.value = false;
                                  })
                              : IconButton(
                                  color: Themes.WHITE,
                                  icon: Icon(
                                    Icons.flip_camera_ios_rounded,
                                    size: (appController.swidth * 0.045),
                                  ),
                                  onPressed: () {
                                    toggleCamera(1);
                                    hcontroller.isFrontCamera.value = true;
                                  });
                        }),
                      ])
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() {
                        return hcontroller.isFlashOn.isTrue
                            ? IconButton(
                                color: Themes.WHITE,
                                icon: Icon(
                                  Icons.flash_off_outlined,
                                  size: (appController.sheight * 0.045),
                                ),
                                onPressed: () {
                                  // controller.setFlashMode(FlashMode.off);
                                  hcontroller.isFlashOn.value = false;
                                })
                            : IconButton(
                                color: Themes.WHITE,
                                icon: Icon(
                                  Icons.flash_on_outlined,
                                  size: (appController.sheight * 0.045),
                                ),
                                onPressed: () {
                                  // controller.setFlashMode(FlashMode.always);
                                  hcontroller.isFlashOn.value = true;
                                });
                      }),
                      SizedBox(
                        width: appController.swidth * .029,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: GestureDetector(
                          onTap: hcontroller.controller.value.isInitialized &&
                                  !hcontroller.controller.value.isRecordingVideo
                              ? onTakePictureButtonPressed
                              : null,
                          child: Container(
                            height: (appController.sheight * 0.075),
                            width: (appController.sheight * 0.075),
                            color: Themes.GREY50,
                            child: Icon(Icons.camera),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: appController.swidth * .029,
                      ),
                      Obx(() {
                        return hcontroller.isFrontCamera.isTrue
                            ? IconButton(
                                color: Themes.WHITE,
                                icon: Icon(
                                  Icons.flip_camera_ios_rounded,
                                  size: (appController.sheight * 0.045),
                                ),
                                onPressed: () {
                                  toggleCamera(0);
                                  hcontroller.isFrontCamera.value = false;
                                })
                            : IconButton(
                                color: Themes.WHITE,
                                icon: Icon(
                                  Icons.flip_camera_ios_rounded,
                                  size: (appController.sheight * 0.045),
                                ),
                                onPressed: () {
                                  toggleCamera(1);
                                  hcontroller.isFrontCamera.value = true;
                                });
                      }),
                    ],
                  )),
      ),
    );
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          hcontroller.imagePath.isEmpty
              ? Container()
              : GestureDetector(
                  onTap: () {
                    Get.to(() => ImagePreview(
                          file: hcontroller.imagePath,
                          imagetype: ImageType.Image,
                        ));
                  },
                  child: SizedBox(
                    child: Image.file(
                      File(hcontroller.imagePath),
                      fit: BoxFit.contain,
                    ),
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
        ],
      ),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    // if (controller != null) {
    //   await controller.dispose();
    // }
    hcontroller.controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    // If the controller is updated then update the UI.
    hcontroller.controller.addListener(() {
      if (mounted) setState(() {});
      if (hcontroller.controller.value.hasError) {
        customSnackbar(
            title: "",
            message:
                'Camera error ${hcontroller.controller.value.errorDescription}');
      }
    });

    try {
      await hcontroller.controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      hcontroller.isCameraInitialized = true;
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String? filePath) {
      if (mounted && filePath!.isNotEmpty) {
        setState(() {
          hcontroller.imagePath = filePath;
        });
        customSnackbar(title: "", message: 'Picture saved to $filePath');
      }
    });
  }

  Future<String?> takePicture() async {
    if (!hcontroller.controller.value.isInitialized) {
      //  CustomSnackBar(title: "", message: 'Error: select a camera first.');
      return null;
    }
    String filePath = "";
    try {
      final file = await hcontroller.controller.takePicture();
      filePath = file.path;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    hcontroller.logError(e.code, e.description!);
    // CustomSnackBar(title: "", message: 'Error: ${e.code}\n${e.description}');
  }
}
