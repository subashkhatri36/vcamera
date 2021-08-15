import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vcamera/app/constant/enums.dart';
import 'package:vcamera/app/modules/home/widget/image_preview.dart';
import 'package:vcamera/app/modules/home/widget/menu_items.dart';
import 'package:vcamera/app/modules/home/widget/screen_reorder.dart';

class HomeController extends GetxController {
  static HomeController homecontroller = Get.find();

  ///Its the list of the menu Items that will be show in homescreen
  List<Widget> menuList = [
    MenuItems(
      iconData: Icons.camera,
      title: 'Camera',
      value: 1,
    ),
    MenuItems(
      iconData: Icons.videocam,
      title: 'Video',
      value: 2,
    ),
    MenuItems(
      iconData: Icons.photo,
      title: 'Gallery',
      value: 3,
    ),
    MenuItems(
      iconData: Icons.screenshot,
      title: 'ScreenShot',
      value: 4,
    ),
    MenuItems(
      iconData: Icons.screenshot,
      title: 'Long ScreenShot',
      value: 5,
    ),
    MenuItems(
      iconData: Icons.video_call,
      title: 'Screen Record',
      value: 6,
    ),
    MenuItems(
      iconData: Icons.wallpaper,
      title: 'Photo Edit',
      value: 7,
    ),
    MenuItems(
      iconData: Icons.center_focus_strong,
      title: 'video Edit',
      value: 7,
    ),
  ];
  a() {
    openCamera();
  }

  ///It is used to pick files form device or used to store files that camera or video clicked
  File? imgFile;

  ///used to picked image
  final imgPicker = ImagePicker();
  RxBool isOpenCamera = false.obs;
  RxBool isOpenGallery = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  ///It will open default camera of the device
  void openCamera() async {
    isOpenCamera.toggle();
    var imgCamera = await imgPicker.pickImage(source: ImageSource.camera);
    if (imgCamera != null) imgFile = File(imgCamera.path);
    Get.back();
    if (imgFile != null)
      Get.to(ImagePreview(imagetype: ImageType.Image, file: imgFile));
    isOpenCamera.toggle();
  }

  void openVideo() async {
    isOpenCamera.toggle();
    var imgVideo = await imgPicker.pickVideo(source: ImageSource.camera);
    if (imgVideo != null) imgFile = File(imgVideo.path);
    Get.back();
    if (imgFile != null)
      Get.to(ImagePreview(imagetype: ImageType.Video, file: imgFile));

    isOpenCamera.toggle();
  }

  void openGallery() async {
    isOpenGallery.toggle();
    var imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    if (imgGallery != null) imgFile = File(imgGallery.path);
    Get.back();
    isOpenGallery.toggle();
  }

  void openScreenShot() {}
  void openLongScreenShot() {}
  void openPhotoEditing() {}
  void openVideoEditing() {}
  void openScreenReorder() {}

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
