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
        final turnCounter =
            _storage.read<int>(StatsControllerKeys.keyTurnsCounter) ?? 0;

        return Scaffold(
            backgroundColor: Colors.white,
            body: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: shortest * 0.08 +
                                0.25 * (c.screenHeight - shortest),
                            bottom: 0.25 * (c.screenHeight - shortest)),
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: shortest * 0.5,
                            height: shortest * 0.5,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: c.screenHeight * 0.04),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _menuButton(
                              text: 'continue_game'.tr,
                              onPressed: ((turnCounter > 0)
                                  ? () => Get.off(() => const GamePage())
                                  : null),
                              shortest: shortest,
                              c: c,
                            ),
                            SizedBox(
                              height: c.screenHeight * 0.01,
                            ),
                            _menuButton(
                              text: 'new_game'.tr,
                              // onPressed: () => Get.off(() => const GamePage()),
                              onPressed: () => Get.to(() => TeamSetupPage()),
                              shortest: shortest,
                              c: c,
                            ),
                          ],
                        ),
                      ),
                      _versionLabel(shortest),
                    ],
                  ),
                ),
              );
            }));
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
    double width = 0.62 * shortest;
    double height = shortest * 0.09;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: shortest * 0.1,
          vertical: shortest * 0.02,
        ),
        fixedSize: Size(width, height),
        textStyle: TextStyle(fontSize: min(shortest * 0.04, 20)),
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
          ConnectionState.done => snap.hasError
              ? 'error_version'.tr
              : 'version'.trParams({'version': snap.data ?? ''}),
          _ => '',
        };
        return Padding(
          padding: EdgeInsets.only(bottom: shortest * 0.002),
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
