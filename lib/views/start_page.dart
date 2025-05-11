import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../controllers/screen_controller.dart';
import '/views/game_page.dart';

class StartPage extends StatelessWidget {
  StartPage({super.key});

  final screenController = Get.put(ScreenController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScreenController>(
      builder: (c) {

        print(c.screenWidth);

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: min(c.screenHeight, c.screenWidth) * 0.5,
                      height: min(c.screenHeight, c.screenWidth) * 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _menuButton(
                        text: 'continue_game'.tr,
                        onPressed: null,
                        c: c,
                      ),
                      SizedBox(height: ((c.screenHeight > c.screenWidth) ? 0.016 : 0) * c.screenHeight),
                      _menuButton(
                        text: 'new_game'.tr,
                        onPressed: () => Get.off(() => const GamePage()),
                        c: c,
                      ),
                    ],
                  ),
                ),
                _versionLabel(c),
              ],
            ),
          ),
        );
      },
    );
  }

  // mały helper dla przycisków
  Widget _menuButton({
    required String text,
    required VoidCallback? onPressed,
    required ScreenController c,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: c.screenWidth * 0.1,
          vertical: c.screenHeight * 0.02,
        ),
        fixedSize: Size(min(c.screenHeight, c.screenWidth) * 0.72, c.screenHeight * 0.07),
        textStyle: TextStyle(fontSize: min(c.screenHeight, c.screenWidth) * 0.05),
      ),
      child: Text(text),
    );
  }

  // etykieta z wersją
  Widget _versionLabel(ScreenController c) {
    return FutureBuilder<String>(
      future: _getAppVersion(),
      builder: (context, snapshot) {
        final txt = switch (snapshot.connectionState) {
          ConnectionState.waiting => 'loading_version'.tr,
          ConnectionState.done    =>
          snapshot.hasError
              ? 'error_version'.tr
              : 'version'.trParams({'version': snapshot.data ?? ''}),
          _ => '',
        };
        return Padding(
          padding: EdgeInsets.only(bottom: c.screenHeight * 0.02),
          child: Text(
            txt,
            style: TextStyle(
              color: Colors.grey,
              fontSize: min(c.screenHeight, c.screenWidth) * 0.03,
            ),
          ),
        );
      },
    );
  }

  Future<String> _getAppVersion() async =>
      (await PackageInfo.fromPlatform()).version;
}
