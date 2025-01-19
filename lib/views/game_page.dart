import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_page_controller.dart';
import 'base_squared.dart';
import 'board_squared.dart';
import 'diagonal_squared.dart';
import 'four_color_squared.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final GamePageController gameController = Get.put(GamePageController());

    const double s = 29 - 1;
    const double t = 350;
    const double l = 3;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: 30,
            left: 140,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Obx(() => Text(
                        'Player ${gameController.colors[gameController.currentPlayer.value]}',
                        style: Get.textTheme.headlineMedium,
                      )),
                  const Text('Your current score is:'),
                  Obx(() => Text(
                        '${gameController.scores}',
                        style: Get.textTheme.headlineMedium,
                      )),
                  Obx(() =>
                      Text('Next player is ${gameController.colors[gameController.nextPlayer.value]}')),
                ],
              ),
            ),
          ),
          // Przycisk w lewym górnym rogu
          Positioned(
            top: 30,
            left: 30,
            child: FloatingActionButton(
              heroTag: 'btn1',
              backgroundColor: Colors.red,
              onPressed: () => gameController.rollDice(player: 1),
              tooltip: 'Roll dice (1 to 6)',
              child: const Icon(Icons.casino),
            ),
          ),
          // Przycisk w prawym górnym rogu
          Positioned(
            top: 30,
            right: 30,
            child: FloatingActionButton(
              heroTag: 'btn2',
              backgroundColor: Colors.green,
              onPressed: () => gameController.rollDice(player: 2),
              tooltip: 'Roll dice (1 to 6)',
              child: const Icon(Icons.casino),
            ),
          ),
          // Przycisk w lewym dolnym rogu
          Positioned(
            bottom: 150,
            left: 30,
            child: FloatingActionButton(
              heroTag: 'btn3',
              backgroundColor: Colors.blue,
              onPressed: () => gameController.rollDice(player: 0),
              tooltip: 'Roll dice (1 to 6)',
              child: const Icon(Icons.casino),
            ),
          ),
          // Przycisk w prawym dolnym rogu
          Positioned(
            bottom: 150,
            right: 30,
            child: FloatingActionButton(
              heroTag: 'btn4',
              backgroundColor: Colors.yellow,
              onPressed: () => gameController.rollDice(player: 3),
              tooltip: 'Roll dice (1 to 6)',
              child: const Icon(Icons.casino),
            ),
          ),
          const Positioned(
            top: t - s * 1,
            left: l + s * 6,
            child: DiagonalSquare(
              color1: Colors.green,
              color2: Colors.red,
              isTopLeftToBottomRight: false,
            ),
          ),
          const Positioned(
            top: t + s * 1,
            left: l + s * 6,
            child: DiagonalSquare(
              color1: Colors.red,
              color2: Colors.blue,
              isTopLeftToBottomRight: true,
            ),
          ),
          const Positioned(
            top: t - s * 1,
            left: l + s * 8,
            child: DiagonalSquare(
              color1: Colors.green,
              color2: Colors.yellow,
              isTopLeftToBottomRight: true,
            ),
          ),
          const Positioned(
            top: t + s * 1,
            left: l + s * 8,
            child: DiagonalSquare(
              color1: Colors.yellow,
              color2: Colors.blue,
              isTopLeftToBottomRight: false,
            ),
          ),
          const Positioned(
            top: t + s * 0,
            left: l + s * 7,
            child: FourColorSquare(
              topLeftColor: Colors.red,
              topRightColor: Colors.green,
              bottomLeftColor: Colors.blue,
              bottomRightColor: Colors.yellow,
              showBorder: true,
              borderColor: Colors.black,
              borderWidth: 0.0,
            ),
          ),
          Positioned(
            top: 40,
            left: 160,
            child: FloatingActionButton(
              heroTag: 'btn9',
              backgroundColor: Colors.tealAccent,
              onPressed: gameController.showBoard,
              tooltip: 'Show info',
              child: const Icon(Icons.info),
            ),
          ),
          Positioned(
            top: 40,
            left: 220,
            child: FloatingActionButton(
              heroTag: 'btn10',
              backgroundColor: Colors.amber,
              onPressed: gameController.endTurn,
              tooltip: 'End of turn',
              child: const Icon(Icons.hourglass_empty),
            ),
          ),

          Positioned(
              top: t,
              left: l,
              child: BoardSquare(index: 15, color: Colors.red.shade100)),
          const Positioned(
              top: t - s * 1, left: l, child: BoardSquare(index: 16)),
          const Positioned(
              top: t - s * 1,
              left: l + s * 1,
              child: BoardSquare(index: 17, color: Colors.red)),
          const Positioned(
              top: t - s * 1, left: l + s * 2, child: BoardSquare(index: 18)),
          const Positioned(
              top: t - s * 1, left: l + s * 3, child: BoardSquare(index: 19)),
          const Positioned(
              top: t - s * 1, left: l + s * 4, child: BoardSquare(index: 20)),
          const Positioned(
              top: t - s * 1, left: l + s * 5, child: BoardSquare(index: 21)),
          //
          const Positioned(
              top: t - s * 2, left: l + s * 6, child: BoardSquare(index: 22)),
          const Positioned(
              top: t - s * 3, left: l + s * 6, child: BoardSquare(index: 23)),
          const Positioned(
              top: t - s * 4, left: l + s * 6, child: BoardSquare(index: 24)),
          const Positioned(
              top: t - s * 5,
              left: l + s * 6,
              child: BoardSquare(index: 25, color: Colors.black38)),
          const Positioned(
              top: t - s * 6, left: l + s * 6, child: BoardSquare(index: 26)),
          const Positioned(
              top: t - s * 7, left: l + s * 6, child: BoardSquare(index: 27)),
          //
          Positioned(
              top: t - s * 7,
              left: l + s * 7,
              child: BoardSquare(index: 28, color: Colors.green.shade100)),
          const Positioned(
              top: t - s * 7, left: l + s * 8, child: BoardSquare(index: 29)),
          const Positioned(
              top: t - s * 6,
              left: l + s * 8,
              child: BoardSquare(index: 30, color: Colors.green)),
          const Positioned(
              top: t - s * 5, left: l + s * 8, child: BoardSquare(index: 31)),
          const Positioned(
              top: t - s * 4, left: l + s * 8, child: BoardSquare(index: 32)),
          const Positioned(
              top: t - s * 3, left: l + s * 8, child: BoardSquare(index: 33)),
          const Positioned(
              top: t - s * 2, left: l + s * 8, child: BoardSquare(index: 34)),
          //
          const Positioned(
              top: t - s * 1, left: l + s * 9, child: BoardSquare(index: 35)),
          const Positioned(
              top: t - s * 1, left: l + s * 10, child: BoardSquare(index: 36)),
          const Positioned(
              top: t - s * 1, left: l + s * 11, child: BoardSquare(index: 37)),
          const Positioned(
              top: t - s * 1,
              left: l + s * 12,
              child: BoardSquare(index: 38, color: Colors.black38)),
          const Positioned(
              top: t - s * 1, left: l + s * 13, child: BoardSquare(index: 39)),
          const Positioned(
              top: t - s * 1, left: l + s * 14, child: BoardSquare(index: 40)),
          Positioned(
              top: t - s * 0,
              left: l + s * 14,
              child: BoardSquare(index: 41, color: Colors.yellow.shade100)),
          //
          const Positioned(
              top: t + s * 1, left: l + s * 14, child: BoardSquare(index: 42)),
          const Positioned(
              top: t + s * 1,
              left: l + s * 13,
              child: BoardSquare(index: 43, color: Colors.yellow)),
          const Positioned(
              top: t + s * 1, left: l + s * 12, child: BoardSquare(index: 44)),
          const Positioned(
              top: t + s * 1, left: l + s * 11, child: BoardSquare(index: 45)),
          const Positioned(
              top: t + s * 1, left: l + s * 10, child: BoardSquare(index: 46)),
          const Positioned(
              top: t + s * 1, left: l + s * 9, child: BoardSquare(index: 47)),
          //
          const Positioned(
              top: t + s * 2, left: l + s * 8, child: BoardSquare(index: 48)),
          const Positioned(
              top: t + s * 3, left: l + s * 8, child: BoardSquare(index: 49)),
          const Positioned(
              top: t + s * 4, left: l + s * 8, child: BoardSquare(index: 50)),
          const Positioned(
              top: t + s * 5,
              left: l + s * 8,
              child: BoardSquare(index: 51, color: Colors.black38)),
          const Positioned(
              top: t + s * 6, left: l + s * 8, child: BoardSquare(index: 52)),
          //
          const Positioned(
              top: t + s * 7, left: l + s * 8, child: BoardSquare(index: 53)),
          Positioned(
              top: t + s * 7,
              left: l + s * 7,
              child: BoardSquare(index: 54, color: Colors.blue.shade100)),
          const Positioned(
              top: t + s * 7, left: l + s * 6, child: BoardSquare(index: 55)),
          //
          const Positioned(
              top: t + s * 6,
              left: l + s * 6,
              child: BoardSquare(index: 4, color: Colors.blue)),
          const Positioned(
              top: t + s * 5, left: l + s * 6, child: BoardSquare(index: 5)),
          const Positioned(
              top: t + s * 4, left: l + s * 6, child: BoardSquare(index: 6)),
          const Positioned(
              top: t + s * 3, left: l + s * 6, child: BoardSquare(index: 7)),
          const Positioned(
              top: t + s * 2, left: l + s * 6, child: BoardSquare(index: 8)),
          //
          const Positioned(
              top: t + s * 1, left: l + s * 5, child: BoardSquare(index: 9)),
          const Positioned(
              top: t + s * 1, left: l + s * 4, child: BoardSquare(index: 10)),
          const Positioned(
              top: t + s * 1, left: l + s * 3, child: BoardSquare(index: 11)),
          const Positioned(
              top: t + s * 1,
              left: l + s * 2,
              child: BoardSquare(index: 12, color: Colors.black38)),
          const Positioned(
              top: t + s * 1, left: l + s * 1, child: BoardSquare(index: 13)),
          const Positioned(
              top: t + s * 1, left: l + s * 0, child: BoardSquare(index: 14)),
          //
          Positioned(
              top: t + s * 6,
              left: l + s * 7,
              child: BoardSquare(index: 56, color: Colors.blue.shade200)),
          Positioned(
              top: t + s * 5,
              left: l + s * 7,
              child: BoardSquare(index: 57, color: Colors.blue.shade200)),
          Positioned(
              top: t + s * 4,
              left: l + s * 7,
              child: BoardSquare(index: 58, color: Colors.blue.shade200)),
          Positioned(
              top: t + s * 3,
              left: l + s * 7,
              child: BoardSquare(index: 59, color: Colors.blue.shade200)),
          const Positioned(
              top: t + s * 1,
              left: l + s * 7,
              child: BoardSquare(index: 61, color: Colors.blue, border: false)),
          Positioned(
              top: t + s * 2,
              left: l + s * 7,
              child: BoardSquare(index: 60, color: Colors.blue.shade200)),
          //
          Positioned(
              top: t + s * 0,
              left: l + s * 1,
              child: BoardSquare(index: 62, color: Colors.red.shade200)),
          Positioned(
              top: t + s * 0,
              left: l + s * 2,
              child: BoardSquare(index: 63, color: Colors.red.shade200)),
          Positioned(
              top: t + s * 0,
              left: l + s * 3,
              child: BoardSquare(index: 64, color: Colors.red.shade200)),
          Positioned(
              top: t + s * 0,
              left: l + s * 4,
              child: BoardSquare(index: 65, color: Colors.red.shade200)),
          const Positioned(
              top: t + s * 0,
              left: l + s * 6,
              child: BoardSquare(index: 67, color: Colors.red, border: false)),
          Positioned(
              top: t + s * 0,
              left: l + s * 5,
              child: BoardSquare(index: 66, color: Colors.red.shade200)),
          //
          Positioned(
              top: t - s * 6,
              left: l + s * 7,
              child: BoardSquare(index: 68, color: Colors.green.shade200)),
          Positioned(
              top: t - s * 5,
              left: l + s * 7,
              child: BoardSquare(index: 69, color: Colors.green.shade200)),
          Positioned(
              top: t - s * 4,
              left: l + s * 7,
              child: BoardSquare(index: 70, color: Colors.green.shade200)),
          Positioned(
              top: t - s * 3,
              left: l + s * 7,
              child: BoardSquare(index: 71, color: Colors.green.shade200)),
          const Positioned(
              top: t - s * 1,
              left: l + s * 7,
              child: BoardSquare(index: 73, color: Colors.green, border: false)),
          Positioned(
              top: t - s * 2,
              left: l + s * 7,
              child: BoardSquare(index: 72, color: Colors.green.shade200)),
          //
          Positioned(
              top: t + s * 0,
              left: l + s * 13,
              child: BoardSquare(index: 74, color: Colors.yellow.shade200)),
          Positioned(
              top: t + s * 0,
              left: l + s * 12,
              child: BoardSquare(index: 75, color: Colors.yellow.shade200)),
          Positioned(
              top: t + s * 0,
              left: l + s * 11,
              child: BoardSquare(index: 76, color: Colors.yellow.shade300)),
          Positioned(
              top: t + s * 0,
              left: l + s * 10,
              child: BoardSquare(index: 77, color: Colors.yellow.shade300)),
          const Positioned(
              top: t + s * 0,
              left: l + s * 8,
              child: BoardSquare(index: 79, color: Colors.yellow, border: false)),
          Positioned(
              top: t + s * 0,
              left: l + s * 9,
              child: BoardSquare(index: 78, color: Colors.yellow.shade400)),
          //
          Positioned(
              top: t + s * 5.5, left: l + s * 3, child: BaseSquare(index: 0, color: Colors.blue.shade200)),
          Positioned(
              top: t + s * 5.5, left: l + s * 4, child: BaseSquare(index: 1, color: Colors.blue.shade200)),
          Positioned(
              top: t + s * 6.5, left: l + s * 3, child: BaseSquare(index: 2, color: Colors.blue.shade200)),
          Positioned(
              top: t + s * 6.5, left: l + s * 4, child: BaseSquare(index: 3, color: Colors.blue.shade200)),
          //
          Positioned(
              top: t - s * 4, left: l + s * 0.5, child: BaseSquare(index: 4, color: Colors.red.shade200)),
          Positioned(
              top: t - s * 4, left: l + s * 1.5, child: BaseSquare(index: 5, color: Colors.red.shade200)),
          Positioned(
              top: t - s * 3, left: l + s * 0.5, child: BaseSquare(index: 6, color: Colors.red.shade200)),
          Positioned(
              top: t - s * 3, left: l + s * 1.5, child: BaseSquare(index: 7, color: Colors.red.shade200)),
          //
          Positioned(
              top: t - s * 6.5,
              left: l + s * 10,
              child: BaseSquare(index: 8, color: Colors.green.shade200)),
          Positioned(
              top: t - s * 6.5,
              left: l + s * 11,
              child: BaseSquare(index: 9, color: Colors.green.shade200)),
          Positioned(
              top: t - s * 5.5,
              left: l + s * 10,
              child: BaseSquare(index: 10, color: Colors.green.shade200)),
          Positioned(
              top: t - s * 5.5,
              left: l + s * 11,
              child: BaseSquare(index: 11, color: Colors.green.shade200)),
          //
          Positioned(
              top: t + s * 3, left: l + s * 12.5, child: BaseSquare(index: 12, color: Colors.yellow.shade200)),
          Positioned(
              top: t + s * 3, left: l + s * 13.5, child: BaseSquare(index: 13, color: Colors.yellow.shade200)),
          Positioned(
              top: t + s * 4, left: l + s * 12.5, child: BaseSquare(index: 14, color: Colors.yellow.shade200)),
          Positioned(
              top: t + s * 4, left: l + s * 13.5, child: BaseSquare(index: 15, color: Colors.yellow.shade200)),
        ],
      ),
    );
  }
}
