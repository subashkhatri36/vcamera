import 'package:flutter/material.dart';
import 'package:vcamera/app/constant/controller.dart';

class MenuItems extends StatelessWidget {
  final IconData iconData;
  final String title;
  final int value;

  const MenuItems(
      {Key? key,
      required this.iconData,
      required this.title,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        getPressed(value);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            // vertical: appController.sheight * .001,
            horizontal: appController.swidth * .01),
        margin: EdgeInsets.symmetric(
            // vertical: appController.sheight * .001,
            horizontal: appController.swidth * .01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(child: Icon(iconData)),
            SizedBox(
              height: appController.sheight * .01,
            ),
            FittedBox(
                child: Text(
              title,
              style: Theme.of(context).textTheme.bodyText1,
            ))
          ],
        ),
      ),
    );
  }

  getPressed(int v) {
    switch (v) {
      case 1:
        return hcontroller.openCamera();
      case 2:
        return hcontroller.openVideo();
      case 3:
        return hcontroller.openGallery();
      case 4:
        return hcontroller.openScreenShot();
      case 5:
        return hcontroller.openLongScreenShot();
      case 6:
        return hcontroller.openScreenReorder();
      case 7:
        return hcontroller.openPhotoEditing();
      case 8:
        return hcontroller.openVideoEditing();

      default:
        return null;
    }
  }
}
