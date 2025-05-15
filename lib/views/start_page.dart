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
    screenController.onReady();
    return GetBuilder<ScreenController>(
      builder: (c) {
        final shortest = min(c.screenHeight, c.screenWidth);

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                /// ---------------- logo ----------------
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: shortest * 0.5,
                      height: shortest * 0.5,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                /// --------------- przyciski -------------
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _menuButton(
                        text: 'continue_game'.tr,
                        onPressed: null,
                        shortest: shortest,
                        c: c,
                      ),
                      SizedBox(
                        height: (c.screenHeight > c.screenWidth ? 0.016 : 0) *
                            c.screenHeight,
                      ),
                      _menuButton(
                        text: 'new_game'.tr,
                        onPressed: () => Get.off(() => const GamePage()),
                        shortest: shortest,
                        c: c,
                      ),
                    ],
                  ),
                ),

                /// ---------- etykieta z wersją ----------
                _versionLabel(shortest),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- helper buttonów ----------------
  Widget _menuButton({
    required String text,
    required VoidCallback? onPressed,
    required double shortest,
    required ScreenController c,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: c.screenWidth * 0.1,
          vertical: c.screenHeight * 0.02,
        ),
        fixedSize: Size(shortest * 0.72, c.screenHeight * 0.07),
        textStyle: TextStyle(fontSize: shortest * 0.05),
      ),
      child: Text(text),
    );
  }

  // -------------- labelka z wersją -----------------
  Widget _versionLabel(double shortest) {
    return FutureBuilder<String>(
      future: _getAppVersion(),
      builder: (context, snap) {
        final txt = switch (snap.connectionState) {
          ConnectionState.waiting => 'loading_version'.tr,
          ConnectionState.done =>
          snap.hasError
              ? 'error_version'.tr
              : 'version'.trParams({'version': snap.data ?? ''}),
          _ => '',
        };
        return Padding(
          padding: EdgeInsets.only(bottom: shortest * 0.08),
          child: Text(
            txt,
            style: TextStyle(color: Colors.grey, fontSize: shortest * 0.03),
          ),
        );
      },
    );
  }

  Future<String> _getAppVersion() async =>
      (await PackageInfo.fromPlatform()).version;
}

