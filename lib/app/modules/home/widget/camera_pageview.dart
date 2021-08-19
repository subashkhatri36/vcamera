import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vcamera/app/constant/controller.dart';
import 'package:vcamera/app/constant/enums.dart';
import 'package:vcamera/app/constant/theme_data.dart';
import 'package:vcamera/app/modules/home/widget/image_preview.dart';
import 'package:vcamera/app/modules/home/widget/save_gallary.dart';
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

  @override
  void initState() {
    ambiguate(WidgetsBinding.instance)?.addObserver(this);
    setCameras();
    animationInitalized();

    super.initState();
  }

  Future<void> setCameras() async {
    hcontroller.cameras = await availableCameras();
    onNewCameraSelected(hcontroller.cameras[0]);
  }

  void animationInitalized() {
    hcontroller.flashModeControlRowAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    hcontroller.flashModeControlRowAnimation = CurvedAnimation(
        parent: hcontroller.flashModeControlRowAnimationController,
        curve: Curves.easeInCubic);

    hcontroller.exposureModeControlRowAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    hcontroller.exposureModeControlRowAnimation = CurvedAnimation(
        parent: hcontroller.exposureModeControlRowAnimationController,
        curve: Curves.easeInCubic);

    hcontroller.focusModeControlRowAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    hcontroller.focusModeControlRowAnimation = CurvedAnimation(
        parent: hcontroller.focusModeControlRowAnimationController,
        curve: Curves.easeInCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: hcontroller.controller == null
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
                if (hcontroller.imageFile != null)
                  Positioned(
                    top: appController.sheight * .05,
                    right: appController.swidth * .03,
                    child: SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: hcontroller.imageFile == null
                          ? appController.imagesFiles.isNotEmpty
                              ? InkWell(
                                  onTap: () {
                                    Get.to(SavedGallary());
                                  },
                                  child: Image.memory(
                                      appController.imagesFiles[0]))
                              : Container()
                          : InkWell(
                              onTap: () {
                                Get.to(ImagePreview(
                                    imagetype: ImageType.Image,
                                    file: hcontroller.imageFile!.path));
                              },
                              child: Image.file(
                                  File(hcontroller.imageFile!.path))),
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
                                  onPressed:
                                      hcontroller.onExposureModeButtonPressed,
                                ),
                                IconButton(
                                  color: Themes.WHITE,
                                  icon: Icon(
                                    hcontroller.controller!.value.flashMode ==
                                            FlashMode.off
                                        ? Icons.flash_off
                                        : hcontroller.controller!.value
                                                    .flashMode ==
                                                FlashMode.auto
                                            ? Icons.flash_auto
                                            : hcontroller.controller!.value
                                                        .flashMode ==
                                                    FlashMode.always
                                                ? Icons.flash_on
                                                : hcontroller.controller!.value
                                                            .flashMode ==
                                                        FlashMode.torch
                                                    ? Icons.highlight
                                                    : Icons.flash_on_outlined,
                                    size: (appController.sheight * 0.045),
                                  ),
                                  onPressed:
                                      hcontroller.onFlashModeButtonPressed,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: GestureDetector(
                                    onTap: hcontroller
                                            .controller!.value.isInitialized
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
                                  icon: Icon(hcontroller.controller!.value
                                          .isCaptureOrientationLocked
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
    hcontroller.controller = CameraController(
      hcontroller.cameras[index],
      ResolutionPreset.medium,
    );

    // If the controller is updated then update the UI.
    hcontroller.controller!.addListener(() {
      if (mounted) setState(() {});
      if (hcontroller.controller!.value.hasError) {
        customSnackbar(
            title: "",
            message:
                'Camera error ${hcontroller.controller!.value.errorDescription}');
      }
    });

    try {
      await hcontroller.controller!.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onCaptureOrientationLockButtonPressed() async {
    // final CameraController cameraController = controller;
    if (hcontroller.controller!.value.isCaptureOrientationLocked) {
      await hcontroller.controller!.unlockCaptureOrientation();
      // customSnackbar(message: 'Capture orientation unlocked');
    } else {
      await hcontroller.controller!.lockCaptureOrientation();
      // customSnackbar(
      //     message:
      //         'Capture orientation locked to ${controller.value.lockedCaptureOrientation.toString().split('.').last}');
    }
    setState(() {});
  }

  void onSetExposureModeButtonPressed(ExposureMode mode) {
    setExposureMode(mode).then((_) {
      if (mounted) setState(() {});
      // customSnackbar(
      //     message: 'Exposure mode set to ${mode.toString().split('.').last}');
    });
  }

  Widget exposureModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(
      primary: hcontroller.controller!.value.exposureMode == ExposureMode.auto
          ? Colors.orange
          : Themes.WHITE,
    );
    final ButtonStyle styleLocked = TextButton.styleFrom(
      primary: hcontroller.controller!.value.exposureMode == ExposureMode.locked
          ? Colors.orange
          : Themes.WHITE,
    );

    return SizeTransition(
      sizeFactor: hcontroller.exposureModeControlRowAnimation,
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
                    onPressed: hcontroller.controller != null
                        ? () =>
                            onSetExposureModeButtonPressed(ExposureMode.auto)
                        : null,
                    onLongPress: () {
                      if (hcontroller.controller != null) {
                        hcontroller.controller!.setExposurePoint(null);
                        //customSnackbar(message: 'Resetting exposure point');
                      }
                    },
                  ),
                  TextButton(
                    child: Text('LOCKED'),
                    style: styleLocked,
                    onPressed: hcontroller.controller != null
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
                    hcontroller.minAvailableExposureOffSet.toString(),
                    style: TextStyle(color: Themes.WHITE),
                  ),
                  Slider(
                    activeColor: Themes.Orange,
                    inactiveColor: Themes.WHITE,
                    value: hcontroller.currentExposureOffset,
                    min: hcontroller.minAvailableExposureOffSet,
                    max: hcontroller.maxAvailableExposureOffset,
                    label: hcontroller.currentExposureOffset.toString(),
                    onChanged: hcontroller.minAvailableExposureOffSet ==
                            hcontroller.maxAvailableExposureOffset
                        ? null
                        : setExposureOffset,
                  ),
                  Text(
                    hcontroller.maxAvailableExposureOffset.toString(),
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

  Future<void> setExposureMode(ExposureMode mode) async {
    try {
      await hcontroller.controller!.setExposureMode(mode);
    } on CameraException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> setExposureOffset(double offset) async {
    setState(() {
      hcontroller.currentExposureOffset = offset;
    });
    try {
      offset = await hcontroller.controller!.setExposureOffset(offset);
    } on CameraException catch (e) {
      print(e);
      rethrow;
    }
  }

  Widget flashModeControlRowWidget() {
    return SizeTransition(
      sizeFactor: hcontroller.flashModeControlRowAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            icon: Icon(Icons.flash_off),
            color: hcontroller.controller!.value.flashMode == FlashMode.off
                ? Colors.orange
                : Themes.WHITE,
            onPressed: () => onSetFlashModeButtonPressed(FlashMode.off),
          ),
          IconButton(
            icon: Icon(Icons.flash_auto),
            color: hcontroller.controller!.value.flashMode == FlashMode.auto
                ? Colors.orange
                : Themes.WHITE,
            onPressed: () => onSetFlashModeButtonPressed(FlashMode.auto),
          ),
          IconButton(
            icon: Icon(Icons.flash_on),
            color: hcontroller.controller!.value.flashMode == FlashMode.always
                ? Colors.orange
                : Themes.WHITE,
            onPressed: () => onSetFlashModeButtonPressed(FlashMode.always),
          ),
          IconButton(
            icon: Icon(Icons.highlight),
            color: hcontroller.controller!.value.flashMode == FlashMode.torch
                ? Colors.orange
                : Themes.WHITE,
            onPressed: () => onSetFlashModeButtonPressed(FlashMode.torch),
          ),
        ],
      ),
    );
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    hcontroller.setFlashMode(mode).then((_) {
      if (mounted) setState(() {});
      // customSnackbar(
      //     message: 'Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (hcontroller.controller == null) return;

    final CameraController cameraController = hcontroller.controller!;
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  void handleScaleStart(ScaleStartDetails details) {
    hcontroller.baseScale = hcontroller.currentScale;
  }

  Future<void> handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (hcontroller.controller == null || hcontroller.pointers != 2) {
      return;
    }

    hcontroller.currentScale = (hcontroller.baseScale * details.scale)
        .clamp(hcontroller.minAvailableZoom, hcontroller.maxAvailablezoom);

    await hcontroller.controller!.setZoomLevel(hcontroller.currentScale);
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          hcontroller.imageFile = file;
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

  Future<XFile?> takePicture() async {
    if (hcontroller.controller!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await hcontroller.controller!.takePicture();
      return file;
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  Widget cameraPreviewWidget() {
    final CameraController? cameraController = hcontroller.controller;

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
        onPointerDown: (_) => hcontroller.pointers++,
        onPointerUp: (_) => hcontroller.pointers--,
        child: CameraPreview(
          hcontroller.controller!,
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      hcontroller.controller!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(hcontroller.controller!.description);
    }

    super.didChangeAppLifecycleState(state);
  }

  //either in rotate or in other
  void onNewCameraSelected(CameraDescription cameraDescription) async {
    hcontroller.isCameraInitialized = false;

    final CameraController cameraController =
        CameraController(cameraDescription, ResolutionPreset.medium,
            // enableAudio: enableAudio,
            imageFormatGroup: ImageFormatGroup.jpeg);
    hcontroller.controller = cameraController;
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
            .then((value) => hcontroller.minAvailableExposureOffSet = value),
        cameraController
            .getMaxExposureOffset()
            .then((value) => hcontroller.maxAvailableExposureOffset = value),
        cameraController
            .getMaxZoomLevel()
            .then((value) => hcontroller.maxAvailablezoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => hcontroller.minAvailableZoom = value),
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
    hcontroller.flashModeControlRowAnimationController.dispose();
    hcontroller.exposureModeControlRowAnimationController.dispose();

    super.dispose();
  }
}

T? ambiguate<T>(T? value) => value;
