import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vcamera/app/constant/controller.dart';
import 'dart:convert';

class SavedGallary extends StatelessWidget {
  const SavedGallary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          itemCount: appController.imagesFiles.length,
          itemBuilder: (context, index) {
            return Container(
              child: Image.memory(
                appController.imagesFiles[index],
              ),
            );
          }),
    );
  }
}
