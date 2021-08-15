import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vcamera/app/constant/constant.dart';
import 'package:vcamera/app/constant/controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    appController.sizeinit(context);
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Expanded(
          flex: 5,
          child: Image.asset(AppImage.icon),
        ),
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Constants.kDefaultPadding / 2),
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisSpacing: 2,
                crossAxisCount: 4,
                mainAxisSpacing: Constants.kDefaultPadding / 2,
                children: controller.menuList.toList(),
              ),
            )),
        SizedBox(
          height: appController.sheight * .1,
          child: Container(),
        )
      ],
    )));
  }
}

// class PickImage extends StatefulWidget {
//   const PickImage({Key? key}) : super(key: key);

//   @override
//   _PickImageState createState() => _PickImageState();
// }

// class _PickImageState extends State<PickImage> {
//   Widget displayImage() {
//     if (imgFile == null) {
//       return Text("No Image Selected!");
//     } else {
//       return Image.file(imgFile!, width: 350, height: 350);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('hello'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             displayImage(),
//             SizedBox(height: 30),
//             RaisedButton(
//               onPressed: () {
//                 showOptionsDialog(context);
//               },
//               child: Text("Select Image"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
