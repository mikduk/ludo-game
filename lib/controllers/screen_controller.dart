import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/widgets.dart';

class ScreenController extends GetxController {
  late double screenWidth;
  late double screenHeight;
  late bool isPortrait;

  @override
  void onInit() {
    screenWidth = 0;
    screenHeight = 0;
    isPortrait = true;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _updateSize();
    _listenOrientation();
  }

  void _updateSize() {
    final mq = Get.mediaQuery;
    final size = mq.size;
    screenWidth  = size.width;
    screenHeight = max(size.height - mq.padding.top - mq.padding.bottom, 10);
    isPortrait   = screenHeight > screenWidth;
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

  double getFieldSize() {
    List<double> d = [1024, 1366];
    if (d.contains(screenWidth) && d.contains(screenHeight)) {
      return min(((10/11) * getBoardHeight() ~/ 15) * 1.0, (isPortrait ? 62.0 : 61.0));
    } else if (screenWidth == 768 && screenHeight == 1024) {
      return 47.5;
    } else if (screenWidth == 390.0 && screenHeight == 844.0) {
      return ((10/11) * getBoardHeight() ~/ 15) * 1.0 - 0.5;
    } else if (screenWidth == 375.0 && screenHeight == 667.0) {
      return ((10/11) * getBoardHeight() ~/ 15) * 1.0 - 0.5;
    } else if (screenWidth == 360.0 && screenHeight == 732.0) {
      return ((10/11) * getBoardHeight() ~/ 15) * 1.0 - 0.5;
    } else if (screenWidth == 360.0 && screenHeight == 752.0) {
      return ((10/11) * getBoardHeight() ~/ 15) * 1.0 - 0.5;
    }
    return min(((10/11) * getBoardHeight() ~/ 15) * 1.0, (isPortrait ? 51.0 : 48.0));
  }

  double getTopMargin() => isPortrait ? Get.mediaQuery.padding.top : 0;
  double getBottomMargin() => isPortrait ? Get.mediaQuery.padding.bottom : 0;
  double getRightMargin() => Get.mediaQuery.padding.right * 0.5;

  bool showNextPlayerString() {
    return true;
  }

  bool horizontalScoreBoard() {
    if (screenHeight > screenWidth) {
      return true;
    }
    return false;
  }

  double getFontSize() {
    return min(0.03 * min(screenWidth, screenHeight), 18);
  }

  double getBoardTopPadding() {
    print('[2] Unknown device size: $screenWidth x $screenHeight');
    if (screenWidth == 1080 && screenHeight == 810) {
      return 12;
    } else if (screenWidth == 1180 && screenHeight == 820) {
      return 14;
    } else if (screenWidth == 1366 && screenHeight == 1024) {
      return 14;
    } else if (screenWidth == 1024 && screenHeight == 768) {
      return 7;
    } else if (screenWidth == 1194 && screenHeight == 834) {
      return 18;
    } else if (screenWidth == 1133 && screenHeight == 744) {
      return 1;
    } else if (screenWidth == 667 && screenHeight == 375) {
      return 10;
    } else if (screenWidth == 926 && screenHeight == 428) {
      return 10;
    } else if (screenWidth == 360 && screenHeight == 752) {
      return 10;
    }
    return 0;
  }

  double getRightScoreBoardPosition() {
    if (screenWidth == 1080 && screenHeight == 810) {
      return screenWidth * 0.012;
    } else if (screenWidth == 1180 && screenHeight == 820) {
      return screenWidth * 0.032;
    } else if (screenWidth == 1366 && screenHeight == 1024) {
      return screenWidth * 0.028;
    } else if (screenWidth == 1194 && screenHeight == 834) {
      return screenWidth * 0.028;
    } else if (screenWidth == 1133 && screenHeight == 744) {
      return screenWidth * 0.028;
    } else if (screenWidth == 844 && screenHeight == 390) {
      return screenWidth * 0.05;
    } else if (screenWidth == 667 && screenHeight == 375) {
      return screenWidth * 0.032;
    } else if (screenWidth == 926 && screenHeight == 428) {
      return screenWidth * 0.038;
    }
    return screenWidth * 0.1;
  }

  double getButtonWidth() {
    if (screenWidth == 844 && screenHeight == 390) {
      return screenWidth * 0.23;
    } else if (screenWidth == 926 && screenHeight == 428) {
      return screenWidth * 0.26;
    } else if (screenWidth == 732 && screenHeight == 360) {
      return screenWidth * 0.1;
    }
    return screenWidth * 0.2;
  }

  double getWidthTwoByTwo() {
    if (screenWidth == 375 && screenHeight == 667) {
      return 0;
    } else if (screenWidth == 360 && screenHeight == 732) {
      return 0;
    }
    return 8;
  }

  double getHeightTwoByTwo() {
    if (screenWidth == 375 && screenHeight == 667) {
      return 2;
    } else if (screenWidth == 360 && screenHeight == 732) {
      return 2;
    }
    return 16;
  }

  double getTopButtonsWidth() {
    if (screenWidth == 375 && screenHeight == 667) {
      return Get.width * 0.4;
    }
    return Get.width * 0.45;
  }
}