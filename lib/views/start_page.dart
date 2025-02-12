import 'package:chinczyk/views/game_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
                    child: const Text('Nowa Gra'),
                  ),
                ],
              ),
            ),
            FutureBuilder<String>(
              future: _getAppVersion(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: Text(
                      'Wersja ładuje się...',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.03,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: Text(
                      'Błąd pobierania wersji',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: screenWidth * 0.03,
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: Text(
                      'Wersja ${snapshot.data}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.03,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
