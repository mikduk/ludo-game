import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/services.dart';
import '/views/game_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  Future<String> _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  @override
  Widget build(BuildContext context) {

    final double screenWidth = Get.width;
    final double screenHeight = Get.height;

    if (screenWidth > 1.8 * screenHeight) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }

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
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.5,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.off(() => const GamePage());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: screenHeight * 0.02,
                      ),
                      textStyle: TextStyle(
                        fontSize: screenWidth * 0.05,
                      ),
                    ),
                    child: Text('new_game'.tr),
                  ),
                ],
              ),
            ),
            FutureBuilder<String>(
              future: _getAppVersion(),
              builder: (context, snapshot) {
                String versionText;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  versionText = 'loading_version'.tr;
                } else if (snapshot.hasError) {
                  versionText = 'error_version'.tr;
                } else {
                  versionText =
                      'version'.trParams({'version': snapshot.data ?? ''});
                }

                return Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                  child: Text(
                    versionText,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: screenWidth * 0.03,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
