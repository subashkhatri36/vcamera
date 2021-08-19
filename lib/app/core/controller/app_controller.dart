import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vcamera/app/constant/controller.dart';
import 'package:vcamera/app/widget/custom_snackbar.dart';

class AppController extends GetxController {
  static AppController instance = Get.find();

  List<Uint8List> imagesFiles = [];

  ///It take the screen width
  double swidth = 0.0;

  ///It take the screen height
  double sheight = 0.0;

  ///It checks that whether user screen is potrate or landscape
  RxBool islandscape = false.obs;

  ///This method return void
  ///It take context of current screen and help to calculate screen height and width
  void sizeinit(BuildContext context) {
    swidth = MediaQuery.of(context).size.width;
    sheight = MediaQuery.of(context).size.height;
    islandscape.value = swidth > 375 ? true : false;
  }

  @override
  void onInit() {
    loadDatabase();
    super.onInit();
  }

  void loadDatabase() async {
    imagesFiles.clear();
    var yourList = await shareInstance.readList('Images');
    for (var list in yourList) {
      imagesFiles.add(base64Decode(list));
    }
  }

  void saveintoDatabase() {
    //prefs.setStringList('key', yourList);
    List<String> imglist = imagesFiles.map((e) => base64Encode(e)).toList();
    print(imglist.toString());
    bool? pre = shareInstance.savelist('Images', imglist);
    if (pre != null) {
      customSnackbar(
          message: 'Saved',
          title: 'Information',
          snackPosition: SnackPosition.TOP);
    }
  }
  /*

static Future<bool> saveImage(List<int> imageBytes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String base64Image = base64Encode(imageBytes);
    return prefs.setString("image", base64Image);
  }

  static Future<Image> getImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Uint8List bytes = base64Decode(prefs.getString("image"));
    return Image.memory(bytes);
  }



  SharedPreferences prefs = await SharedPreferences.getInstance();
List<Entry> entries = // insert your objects here ;
final String entriesJson = json.encode(entries.map((entry) => entry.toJson()).toList());
prefs.setString('entries', entriesJson);
final String savedEntriesJson = prefs.getString('entries);
final List<dynamic> entriesDeserialized = json.decode(savedEntriesJson);
List<Entry> deserializedEntries = entriesDeserialized.map((json) => Entry.fromJson(json)).toList();
   */
}
