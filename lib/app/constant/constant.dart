import 'package:vcamera/app/utlis/filters.dart';

const String APP_NAME = "Vcamera";

class Constants {
  static const double kDefaultPadding = 16.0;
  static const double kDefaultmargin = 16.0;
  static const double kRadius = 20.0;
}

class Strings {}

class AssetLink {
  static const dogModelUnquanty = 'assets/ml/model_unquant.tflite';
  static const doglabel = 'assets/ml/labels.txt';
}

class AppImage {
  static const icon = "assets/images/icon.png";
  static const fliterImage = "assets/images/showimage.jpg";
}

final List<List<double>> filters = [
  SEPIA_MATRIX,
  GREYSCALE_MATRIX,
  VINTAGE_MATRIX,
  SWEET_MATRIX,
  SEPIEM_MATRIX,
  CLOUD_MATRIX,
  CYAN_MATRIX,
  YELLOW_MATRIX,
  PRURPLE_MATRIX
];
