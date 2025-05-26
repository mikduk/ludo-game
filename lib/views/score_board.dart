import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/game_page_controller.dart';
import '../controllers/screen_controller.dart';
import 'player_dice.dart';

class ScoreBoard extends StatelessWidget {
  final GamePageController gameController;

  const ScoreBoard({super.key, required this.gameController});

  @override
  Widget build(BuildContext context) {
    final ScreenController screenController = Get.find();
    double h = screenController.getBoardHeight() / 410;
    bool vertical = screenController.isPortrait;
    vertical = screenController.horizontalScoreBoard();

    List<Widget> children = [
      if (vertical)
        const PlayerDice(),
      SizedBox(
        height: vertical ? 0 : 2,
        width: vertical ? 15 * h : 0,
      ),
      Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCurrentPlayerInfo(),
          if (vertical && screenController.showNextPlayerString())
            Text(
              'next_player'.tr,
              style: TextStyle(
                color: Colors.black38,
                fontSize: screenController.getFontSize()
              )
            ),
          if (vertical)
            SizedBox(height: h),
          if (vertical)
            _buildNextPlayerInfo(),
        ],
      ),
      SizedBox(
        height: vertical ? 0 : 2,
        width: vertical ? 15 * h : 0,
      ),
      Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDiceResult(
              screenController.getFieldSize(), h, vertical),
        ],
      ),
      if (!vertical &&
          screenController.getBoardHeight() > 600)
        SizedBox(
          height: vertical ? 0 : 0,
          width: vertical ? 20 : 0,
        ),
      if (!vertical && screenController.showNextPlayerString())
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                'next_player'.tr,
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: screenController.getFontSize()
                )
            ),
            SizedBox(height: h),
            _buildNextPlayerInfo(),
          ],
        ),
      SizedBox(
        height: vertical ? 0 : 2,
        width: vertical ? 15 * h : 0,
      ),
      if (!vertical)
        const SizedBox(height: 4),
      if (!vertical)
        const PlayerDice(),
      if (!vertical)
        const SizedBox(height: 10),
    ];

    return Center(
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: vertical
            ? Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 6 * h, horizontal: 16 * h),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children),
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 6 * h, horizontal: 24),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children),
              ),
      ),
    );
  }

  /// Sekcja: "Aktualny gracz"
  Widget _buildCurrentPlayerInfo() {
    final ScreenController screenController = Get.find();
    return Obx(() {
      final String currentName =
          gameController.colors[gameController.currentPlayer.value];
      List<Color?> color = [
        Colors.blue[700],
        Colors.red[700],
        Colors.green[700],
        Colors.yellow[700]
      ];
      return Column(
        children: [
          Text(
              'current_player'.tr,
              style: TextStyle(
                  color: Colors.black38,
                  fontSize: screenController.getFontSize()
              )
          ),
          const SizedBox(height: 4),
          Text(
            currentName,
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color[gameController.currentPlayer.value],
            ),
          ),
        ],
      );
    });
  }

  /// Sekcja z kostką i wynikiem
  Widget _buildDiceResult(double size, double h, bool portrait) {
    return Obx(() {
      final score = gameController.score.value;
      return Column(
        children: [
          Text(
            'Wynik:',
            style: Get.textTheme.titleMedium,
          ),
          SizedBox(height: 4 * h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
            child: _buildDiceFace(size, score, portrait,
                key: ValueKey<int>(score)),
          ),
          SizedBox(height: 4 * h),
          Text(
            '${gameController.scores}',
            style: Get.textTheme.headlineSmall,
          ),
        ],
      );
    });
  }

  /// Buduje "twarz" kostki dla wyniku 1–6 za pomocą Stacka i kropek.
  Widget _buildDiceFace(double size, int score, bool portait, {Key? key}) {
    double s = 0.01 * size * (portait ? 1.9 : 2.2);
    return Container(
      key: key,
      width: 100 * s,
      height: 100 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8 * s),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      // Używamy Stacka, aby rozmieścić kropki w odpowiednich pozycjach
      child: Stack(
        children: _buildPips(score, s),
      ),
    );
  }

  /// Zwraca listę kropek (Widgetów) odpowiednio ułożonych zależnie od wyniku
  List<Widget> _buildPips(int score, double s) {
    // Wspólne parametry kropek (rozmiar, kolor, zaokrąglenie)
    double pipSize = 18 * s;
    final pipDecoration = BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(s * pipSize / 2),
    );

    // Pomocniczo definiujemy kilka pozycji do użycia w Stacku
    // (góra-lewo, góra-prawo, środek, dół-lewo itd.)
    // Wartości w procentach, np. FractionalOffset
    final topLeft = Positioned(
      left: 8 * s,
      top: 8 * s,
      child:
          Container(width: pipSize, height: pipSize, decoration: pipDecoration),
    );
    final topRight = Positioned(
      right: 8 * s,
      top: 8 * s,
      child:
          Container(width: pipSize, height: pipSize, decoration: pipDecoration),
    );
    final centerLeft = Positioned(
      left: 8 * s,
      top: 42 * s,
      child:
          Container(width: pipSize, height: pipSize, decoration: pipDecoration),
    );
    final center = Positioned(
      left: 42 * s,
      top: 42 * s,
      child:
          Container(width: pipSize, height: pipSize, decoration: pipDecoration),
    );
    final centerRight = Positioned(
      right: 8 * s,
      top: 42 * s,
      child:
          Container(width: pipSize, height: pipSize, decoration: pipDecoration),
    );
    final bottomLeft = Positioned(
      left: 8 * s,
      bottom: 8 * s,
      child:
          Container(width: pipSize, height: pipSize, decoration: pipDecoration),
    );
    final bottomRight = Positioned(
      right: 8 * s,
      bottom: 8 * s,
      child:
          Container(width: pipSize, height: pipSize, decoration: pipDecoration),
    );

    // Zależnie od wyniku 1-6 zwracamy odpowiednie kropki
    switch (score) {
      case 1:
        return [center];
      case 2:
        return [topLeft, bottomRight];
      case 3:
        return [topLeft, center, bottomRight];
      case 4:
        return [topLeft, topRight, bottomLeft, bottomRight];
      case 5:
        return [topLeft, topRight, center, bottomLeft, bottomRight];
      case 6:
        return [
          topLeft,
          centerLeft,
          topRight,
          bottomLeft,
          centerRight,
          bottomRight
        ];
      default:
        // nie powinno wystąpić, ale zwróćmy pustą listę
        return [];
    }
  }

  /// Sekcja: "Następny gracz"
  Widget _buildNextPlayerInfo() {
    List<Color?> color = [
      Colors.blue[700],
      Colors.red[700],
      Colors.green[700],
      Colors.yellow[700]
    ];
    return Obx(() {
      final nextColor = gameController.colors[gameController.nextPlayer.value];
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.arrow_right_alt),
          const SizedBox(width: 8),
          Text(
            nextColor,
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color[gameController.nextPlayer.value],
            ),
          ),
        ],
      );
    });
  }
}
