import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../controllers/screen_controller.dart';
import '../models/keys/stats_controller_keys.dart';
import '/views/team_setup_page.dart';
import 'basic_page.dart';
import 'game_page.dart';

class StartPage extends BasicPage {
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                            menuButton(
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
                            menuButton(
                              text: 'new_game'.tr,
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
          padding: EdgeInsets.only(bottom: shortest * 0.02),
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
