import 'package:flutter/material.dart';
import 'package:vcamera/app/constant/constant.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {Key? key,
      this.color,
      required this.label,
      this.btnColor = Colors.red,
      required this.onpress})
      : super(key: key);
  final String label;
  final Function onpress;
  final Color? color;
  final Color btnColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(Constants.kRadius)),
      padding: EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
      //alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: btnColor,
              primary: color ?? Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Text(
            label,
            // style: Theme.of(context)
            //     .textTheme
            //     .bodyText1!
            //     .copyWith(color: color ?? Theme.of(context).accentColor),
          ),
          onPressed: () {
            onpress();
          }),
    );
  }
}

/// custom raised/elevated button widget
class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    required this.label,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 50,
      child: ElevatedButton(
        child: new Text(
          label,
          textAlign: TextAlign.center,
        ),
        onPressed: onPressed,
        // style: ElevatedButton.styleFrom(
        //   primary: Themes.GREY, // background
        //   onPrimary: Themes.BLACK, // foreground/text
        //   onSurface: Themes.GREY, // disabled
        //   textStyle: TextStyle(
        //       fontWeight: FontWeight.normal,
        //       fontSize: Constants.defaultFontSize),
        // ),
      ),
    );
  }
}

/// custom outlined button widget
class CustomOutlinedButton extends StatelessWidget {
  CustomOutlinedButton({
    required this.label,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: new Text(label, textAlign: TextAlign.center),
      onPressed: onPressed,
      // style: OutlinedButton.styleFrom(
      //   primary: Colors.white, // foreground
      //   onSurface: Colors.grey, // disabled
      //   backgroundColor: Colors.teal, // background
      // ),
    );
  }
}
