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
    final size = Get.mediaQuery.size;
    screenWidth  = size.width;
    screenHeight = size.height;
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
    if (screenWidth == 844 && screenHeight == 390) {
      return false;
    }
    return true;
  }

  bool horizontalScoreBoard() {
    //
    // iPhone SE (2/3 gen) / iPhone 8
    // Portret: 375 × 667
    // Poziom: 667 × 375
    if (screenWidth == 667 && screenHeight == 375) {
      return false;
    } else if (screenWidth == 375 && screenHeight == 667) {
      return false;
    }

    // Samsung A35
    if (screenWidth >= 700 && screenWidth <= 710 && screenHeight == 360) {
      return false;
    } else if (screenWidth == 360 && screenHeight == 732) {
      return false;
    }

    //
    // iPhone 11 / XR
    // Portret: 414 × 896
    // Poziom: 896 × 414
    if (screenWidth == 896 && screenHeight == 414) {
      return true;
    } else if (screenWidth == 414 && screenHeight == 896) {
      return false;
    }

    //
    // iPhone 12 / 12 Pro / 13 / 14 (6.1")
    // Portret: 390 × 844
    // Poziom: 844 × 390
    if (screenWidth == 844 && screenHeight == 390) {
      return true;
    } else if (screenWidth == 390 && screenHeight == 844) {
      return false;
    }

    //
    // iPhone 12 mini / 13 mini (5.4")
    // Portret: 360 × 780
    // Poziom: 780 × 360
    if (screenWidth == 780 && screenHeight == 360) {
      return true;
    } else if (screenWidth == 360 && screenHeight == 780) {
      return false;
    }

    //
    // iPhone 12 Pro Max / 13 Pro Max / 14 Plus (6.7")
    // Portret: 428 × 926
    // Poziom: 926 × 428
    if (screenWidth == 926 && screenHeight == 428) {
      return true;
    } else if (screenWidth == 428 && screenHeight == 926) {
      return false;
    }

    //
    // iPhone 14 Pro (6.1" – ale inny dp: 393 × 852)
    // Portret: 393 × 852
    // Poziom: 852 × 393
    if (screenWidth == 852 && screenHeight == 393) {
      return true;
    } else if (screenWidth == 393 && screenHeight == 852) {
      return false;
    }

    //
    // iPhone 14 Pro Max (6.7" – inny dp: 430 × 932)
    // Portret: 430 × 932
    // Poziom: 932 × 430
    if (screenWidth == 932 && screenHeight == 430) {
      return true;
    } else if (screenWidth == 430 && screenHeight == 932) {
      return false;
    }

    // RealMe
    if (screenWidth >= 900 && screenWidth <= 920 && screenHeight >= 410 && screenHeight <= 430) {
      return true;
    } else if (screenHeight >= 900 && screenHeight <= 920 && screenWidth >= 410 && screenWidth <= 430) {
      return false;
    }

    //
    // iPad 9. gen (10.2")
    // Portret: 810 × 1080
    // Poziom: 1080 × 810
    if (screenWidth == 1080 && screenHeight == 810) {
      return false;
    } else if (screenWidth == 810 && screenHeight == 1080) {
      return true;
    }

    //
    // iPad mini 6. gen (8.3")
    // Portret: 744 × 1133
    // Poziom: 1133 × 744
    if (screenWidth == 1133 && screenHeight == 744) {
      return false;
    } else if (screenWidth == 744 && screenHeight == 1133) {
      return true;
    }

    //
    // iPad Air 4. gen (10.9")
    // Portret: 820 × 1180
    // Poziom: 1180 × 820
    if (screenWidth == 1180 && screenHeight == 820) {
      return false;
    } else if (screenWidth == 820 && screenHeight == 1180) {
      return true;
    }

    //
    // iPad Pro 11"
    // Portret: 834 × 1194
    // Poziom: 1194 × 834
    if (screenWidth == 1194 && screenHeight == 834) {
      return false;
    } else if (screenWidth == 834 && screenHeight == 1194) {
      return true;
    }

    //
    // iPad Pro 12.9" (5./6. gen)
    // Portret: 1024 × 1366
    // Poziom: 1366 × 1024
    if (screenWidth == 1366 && screenHeight == 1024) {
      return false;
    } else if (screenWidth == 1024 && screenHeight == 1366) {
      return true;
    }

    if (screenWidth == 752 && screenHeight == 360) {
      return false;
    } else if (screenWidth == 360 && screenHeight == 752) {
      return false;
    }

    // Jeśli żaden wariant nie pasuje, wyrzucamy w logu wymiary
    print('[1] Unknown device size: $screenWidth x $screenHeight');
    return isPortrait;
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