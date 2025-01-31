import 'package:get/get.dart';
import 'package:flutter/widgets.dart';

class ScreenController extends GetxController {
  double screenWidth = Get.size.width;
  double screenHeight = Get.size.height;
  bool isPortrait = Get.size.height > Get.size.width;

  @override
  void onInit() {
    super.onInit();
    _listenOrientation();
  }

  void _listenOrientation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool newIsPortrait = Get.size.height > Get.size.width;
      double newWidth = Get.size.width;
      double newHeight = Get.size.height;

      if (isPortrait != newIsPortrait || screenWidth != newWidth || screenHeight != newHeight) {
        isPortrait = newIsPortrait;
        screenWidth = newWidth;
        screenHeight = newHeight;
        update();
      }
      _listenOrientation();
    });
  }

  double getBoardHeight() => isPortrait ? screenWidth * 1.1 : screenHeight;
  double getBoardWidth() => isPortrait ? screenWidth  : screenHeight;
  double getFieldSize() => ((10/11) * getBoardHeight() ~/ 15) * 1.0;
  double getTopMargin() => isPortrait ? screenHeight * 0.1 : 0;
}
