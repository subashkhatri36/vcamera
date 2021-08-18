import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vcamera/app/constant/constant.dart';
import 'package:vcamera/app/constant/controller.dart';
import 'package:vcamera/app/constant/enums.dart';
import 'package:vcamera/app/constant/theme_data.dart';
import 'package:vcamera/app/modules/home/widget/image_preview.dart';
import 'package:vcamera/app/widget/custom_snackbar.dart';

///This widget help to view camera and shoot photo
class CameraPageView extends StatefulWidget {
  const CameraPageView({Key? key}) : super(key: key);

  @override
  _CameraPageViewState createState() => _CameraPageViewState();
}

class _CameraPageViewState extends State<CameraPageView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ///camera controller
  CameraController? controller;

  Future<void>? initializeControllerFuture;

  List<CameraDescription> cameras = [];

  bool isCameraInitialized = false;

//file to sore image
  XFile? imageFile;

  ///Exposure setting
  double minAvailableExposureOffSet = 0.0;
  double maxAvailableExposureOffset = 0.0;
  double currentExposureOffset = 0.0;

//working for flash
  late AnimationController flashModeControlRowAnimationController;
  late Animation<double> flashModeControlRowAnimation;
//exposure animation
  late AnimationController exposureModeControlRowAnimationController;
  late Animation<double> exposureModeControlRowAnimation;
//foused mode animation
  late AnimationController focusModeControlRowAnimationController;
  late Animation<double> focusModeControlRowAnimation;

  // bool enableAudio = false;

//zoom size
  double minAvailableZoom = 1.0;
  double maxAvailablezoom = 1.0;
  double currentScale = 1.0;
  double baseScale = 1.0;

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  ///counting pointers(number of user fingers on screen)
  int pointers = 0;
  @override
  void initState() {
    ambiguate(WidgetsBinding.instance)?.addObserver(this);
    setCameras();
    animationInitalized();
    super.initState();
  }

  void animationInitalized() {
    flashModeControlRowAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    flashModeControlRowAnimation = CurvedAnimation(
        parent: flashModeControlRowAnimationController,
        curve: Curves.easeInCubic);

    exposureModeControlRowAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    exposureModeControlRowAnimation = CurvedAnimation(
        parent: exposureModeControlRowAnimationController,
        curve: Curves.easeInCubic);

    focusModeControlRowAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    focusModeControlRowAnimation = CurvedAnimation(
        parent: focusModeControlRowAnimationController,
        curve: Curves.easeInCubic);
  }

  Future<void> setCameras() async {
    cameras = await availableCameras();
    onNewCameraSelected(cameras[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: controller == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Column(
                  children: [
                    Expanded(child: cameraPreviewWidget()),
                  ],
                ),

                // close Button and image preview
                Positioned(
                  top: appController.sheight * .05,
                  left: appController.swidth * .03,
                  child: CircleAvatar(
                    backgroundColor: Themes.WHITE.withOpacity(.7),
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                if (imageFile != null)
                  Positioned(
                    top: appController.sheight * .05,
                    right: appController.swidth * .03,
                    child: SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: InkWell(
                          onTap: () {
                            Get.to(ImagePreview(
                                imagetype: ImageType.Image,
                                file: imageFile!.path));
                          },
                          child: Image.file(File(imageFile!.path))),
                    ),
                  ),

                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    width: appController.swidth,
                    child: Column(
                      children: [
                        flashModeControlRowWidget(),
                        exposureModeControlRowWidget(),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: appController.sheight * .015),
                          color: Colors.black.withOpacity(.1),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.exposure),
                                  color: Themes.WHITE,
                                  onPressed: onExposureModeButtonPressed,
                                ),
                                IconButton(
                                  color: Themes.WHITE,
                                  icon: Icon(
                                    controller!.value.flashMode == FlashMode.off
                                        ? Icons.flash_off
                                        : controller!.value.flashMode ==
                                                FlashMode.auto
                                            ? Icons.flash_auto
                                            : controller!.value.flashMode ==
                                                    FlashMode.always
                                                ? Icons.flash_on
                                                : controller!.value.flashMode ==
                                                        FlashMode.torch
                                                    ? Icons.highlight
                                                    : Icons.flash_on_outlined,
                                    size: (appController.sheight * 0.045),
                                  ),
                                  onPressed: onFlashModeButtonPressed,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: GestureDetector(
                                    onTap: controller!.value.isInitialized
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
                                Obx(() {
                                  return hcontroller.isFrontCamera.isTrue
                                      ? IconButton(
                                          color: Themes.WHITE,
                                          icon: Icon(
                                            Icons.flip_camera_ios_rounded,
                                            size:
                                                (appController.sheight * 0.045),
                                          ),
                                          onPressed: () {
                                            toggleCamera(0);
                                            hcontroller.isFrontCamera.value =
                                                false;
                                          })
                                      : IconButton(
                                          color: Themes.WHITE,
                                          icon: Icon(
                                            Icons.flip_camera_ios_rounded,
                                            size:
                                                (appController.sheight * 0.045),
                                          ),
                                          onPressed: () {
                                            toggleCamera(1);
                                            hcontroller.isFrontCamera.value =
                                                true;
                                          });
                                }),
                                IconButton(
                                  icon: Icon(controller!
                                          .value.isCaptureOrientationLocked
                                      ? Icons.screen_lock_rotation
                                      : Icons.screen_rotation),
                                  color: Themes.WHITE,
                                  onPressed:
                                      onCaptureOrientationLockButtonPressed,
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  void toggleCamera([int index = 0]) async {
    controller = CameraController(
      cameras[index],
      ResolutionPreset.medium,
    );

    // If the controller is updated then update the UI.
    controller!.addListener(() {
      if (mounted) setState(() {});
      if (controller!.value.hasError) {
        customSnackbar(
            title: "",
            message: 'Camera error ${controller!.value.errorDescription}');
      }
    });

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onCaptureOrientationLockButtonPressed() async {
    // final CameraController cameraController = controller;
    if (controller!.value.isCaptureOrientationLocked) {
      await controller!.unlockCaptureOrientation();
      // customSnackbar(message: 'Capture orientation unlocked');
    } else {
      await controller!.lockCaptureOrientation();
      // customSnackbar(
      //     message:
      //         'Capture orientation locked to ${controller.value.lockedCaptureOrientation.toString().split('.').last}');
    }
    setState(() {});
  }

  Widget exposureModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(
      primary: controller!.value.exposureMode == ExposureMode.auto
          ? Colors.orange
          : Themes.WHITE,
    );
    final ButtonStyle styleLocked = TextButton.styleFrom(
      primary: controller!.value.exposureMode == ExposureMode.locked
          ? Colors.orange
          : Themes.WHITE,
    );

    return SizeTransition(
      sizeFactor: exposureModeControlRowAnimation,
      child: ClipRect(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextButton(
                    child: Text('AUTO'),
                    style: styleAuto,
                    onPressed: controller != null
                        ? () =>
                            onSetExposureModeButtonPressed(ExposureMode.auto)
                        : null,
                    onLongPress: () {
                      if (controller != null) {
                        controller!.setExposurePoint(null);
                        //customSnackbar(message: 'Resetting exposure point');
                      }
                    },
                  ),
                  TextButton(
                    child: Text('LOCKED'),
                    style: styleLocked,
                    onPressed: controller != null
                        ? () =>
                            onSetExposureModeButtonPressed(ExposureMode.locked)
                        : null,
                  ),
                ],
              ),
              Center(
                child: Text(
                  "Exposure Offset",
                  style: TextStyle(color: Themes.WHITE),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    minAvailableExposureOffSet.toString(),
                    style: TextStyle(color: Themes.WHITE),
                  ),
                  Slider(
                    activeColor: Themes.Orange,
                    inactiveColor: Themes.WHITE,
                    value: currentExposureOffset,
                    min: minAvailableExposureOffSet,
                    max: maxAvailableExposureOffset,
                    label: currentExposureOffset.toString(),
                    onChanged:
                        minAvailableExposureOffSet == maxAvailableExposureOffset
                            ? null
                            : setExposureOffset,
                  ),
                  Text(
                    maxAvailableExposureOffset.toString(),
                    style: TextStyle(color: Themes.WHITE),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSetExposureModeButtonPressed(ExposureMode mode) {
    setExposureMode(mode).then((_) {
      if (mounted) setState(() {});
      // customSnackbar(
      //     message: 'Exposure mode set to ${mode.toString().split('.').last}');
    });
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    try {
      await controller!.setExposureMode(mode);
    } on CameraException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> setExposureOffset(double offset) async {
    setState(() {
      currentExposureOffset = offset;
    });
    try {
      offset = await controller!.setExposureOffset(offset);
    } on CameraException catch (e) {
      print(e);
      rethrow;
    }
  }

  void onFlashModeButtonPressed() {
    if (flashModeControlRowAnimationController.value == 1) {
      flashModeControlRowAnimationController.reverse();
    } else {
      flashModeControlRowAnimationController.forward();
      exposureModeControlRowAnimationController.reverse();
    }
  }

  void onExposureModeButtonPressed() {
    if (exposureModeControlRowAnimationController.value == 1) {
      exposureModeControlRowAnimationController.reverse();
    } else {
      exposureModeControlRowAnimationController.forward();
      flashModeControlRowAnimationController.reverse();
      // _focusModeControlRowAnimationController.reverse();
    }
  }

  Widget flashModeControlRowWidget() {
    return SizeTransition(
      sizeFactor: flashModeControlRowAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            icon: Icon(Icons.flash_off),
            color: controller!.value.flashMode == FlashMode.off
                ? Colors.orange
                : Themes.WHITE,
            onPressed: () => onSetFlashModeButtonPressed(FlashMode.off),
          ),
          IconButton(
            icon: Icon(Icons.flash_auto),
            color: controller!.value.flashMode == FlashMode.auto
                ? Colors.orange
                : Themes.WHITE,
            onPressed: () => onSetFlashModeButtonPressed(FlashMode.auto),
          ),
          IconButton(
            icon: Icon(Icons.flash_on),
            color: controller!.value.flashMode == FlashMode.always
                ? Colors.orange
                : Themes.WHITE,
            onPressed: () => onSetFlashModeButtonPressed(FlashMode.always),
          ),
          IconButton(
            icon: Icon(Icons.highlight),
            color: controller!.value.flashMode == FlashMode.torch
                ? Colors.orange
                : Themes.WHITE,
            onPressed: () => onSetFlashModeButtonPressed(FlashMode.torch),
          ),
        ],
      ),
    );
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) setState(() {});
      // customSnackbar(
      //     message: 'Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }
    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      print(e);
      customSnackbar(
          message: 'Cannot Appicable', snackPosition: SnackPosition.TOP);
      //rethrow;
    }
  }

  Widget cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => pointers++,
        onPointerUp: (_) => pointers--,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: handleScaleStart,
              onScaleUpdate: handleScaleUpdate,
              onTapDown: (details) => onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) return;

    final CameraController cameraController = controller!;
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  void handleScaleStart(ScaleStartDetails details) {
    baseScale = currentScale;
  }

  Future<void> handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || pointers != 2) {
      return;
    }

    currentScale =
        (baseScale * details.scale).clamp(minAvailableZoom, maxAvailablezoom);

    await controller!.setZoomLevel(currentScale);
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          imageFile = file;
        });
        // if (file != null)
        //   customSnackbar(message: 'Picture saved to ${file.path}');
      }
    });
  }

  onSetFocusModeButtonPressed() {
    // setFocusMode(FocusMode.auto).then((_) {
    //   if (mounted) setState(() {});
    //   //showInSnackBar('Focus mode set to ${mode.toString().split('.').last}');
    // });
  }

  Future<void> setFocusMode(FocusMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFocusMode(mode);
    } on CameraException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<XFile?> takePicture() async {
    if (controller!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await controller!.takePicture();
      return file;
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      controller!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(controller!.description);
    }

    super.didChangeAppLifecycleState(state);
  }

  //either in rotate or in other
  void onNewCameraSelected(CameraDescription cameraDescription) async {
    isCameraInitialized = false;

    final CameraController cameraController =
        CameraController(cameraDescription, ResolutionPreset.medium,
            // enableAudio: enableAudio,
            imageFormatGroup: ImageFormatGroup.jpeg);
    controller = cameraController;
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        customSnackbar(
            message: 'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();

      await Future.wait([
        cameraController
            .getMinExposureOffset()
            .then((value) => minAvailableExposureOffSet = value),
        cameraController
            .getMaxExposureOffset()
            .then((value) => maxAvailableExposureOffset = value),
        cameraController
            .getMaxZoomLevel()
            .then((value) => maxAvailablezoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => minAvailableZoom = value),
      ]);
      onSetFocusModeButtonPressed();
    } on CameraException catch (e) {
      print(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    flashModeControlRowAnimationController.dispose();
    exposureModeControlRowAnimationController.dispose();

    super.dispose();
  }
}

T? ambiguate<T>(T? value) => value;
