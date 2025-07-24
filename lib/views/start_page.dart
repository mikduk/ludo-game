import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../controllers/screen_controller.dart';
import '../models/keys/stats_controller_keys.dart';
import '/views/team_setup_page.dart';
import 'game_page.dart';

class StartPage extends StatelessWidget {
  StartPage({super.key});

  final screenController = Get.put(ScreenController());
  final GetStorage _storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    screenController.onReady();
    return GetBuilder<ScreenController>(
      builder: (c) {
        final shortest = min(c.screenHeight, c.screenWidth);
        final turnCounter = _storage.read<int>(StatsControllerKeys.keyTurnsCounter) ?? 0;

        print('turnCounter: $turnCounter');

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
                        onPressed: ((turnCounter > 0) ? () => Get.off(() => const GamePage()) : null),
                        shortest: shortest,
                        c: c,
                      ),
                      SizedBox(
                        height: (c.screenHeight > c.screenWidth ? 0.016 : 0.008) *
                            c.screenHeight,
                      ),
                      _menuButton(
                        text: 'new_game'.tr,
                        // onPressed: () => Get.off(() => const GamePage()),
                        onPressed: () => Get.off(() => TeamSetupPage()),
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

    double width = min(shortest * 0.72, c.screenHeight * 0.52);
    double height = max(shortest * 0.085, c.screenHeight * 0.07);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: c.screenWidth * 0.1,
          vertical: c.screenHeight * 0.02,
        ),
        fixedSize: Size(width, height),
        textStyle: TextStyle(fontSize: min(shortest * 0.04, 24)),
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

