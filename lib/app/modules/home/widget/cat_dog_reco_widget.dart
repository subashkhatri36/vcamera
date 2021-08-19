import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:vcamera/app/constant/constant.dart';

class CatDogRecognization extends StatefulWidget {
  const CatDogRecognization({Key? key}) : super(key: key);

  @override
  _CatDogRecognizationState createState() => _CatDogRecognizationState();
}

class _CatDogRecognizationState extends State<CatDogRecognization> {
  XFile? _image;
  List? _output;
  bool _loaading = true;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  dectectImage(XFile image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output;
      _loaading = false;
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: AssetLink.dogModelUnquanty, labels: AssetLink.doglabel);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  pickImage() async {
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      _image = image;
    });
    dectectImage(_image!);
  }

  pickGalleryImage() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _image = image;
    });
    dectectImage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              pickImage();
            },
            icon: Icon(Icons.phone),
          ),
          IconButton(
            onPressed: () {
              pickGalleryImage();
            },
            icon: Icon(Icons.phone),
          )
        ],
      ),
      body: _loaading
          ? Container()
          : Container(
              child: Column(
                children: [
                  if (_image != null) Image.file(File(_image!.path)),
                  _output != null
                      ? Text('${_output![0]['label']}')
                      : Container(),
                ],
              ),
            ),
    );
  }
}
