import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_page_controller.dart';
import 'board_squared.dart';

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
      child:
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Obx(() => Text(
                  'Player ${gameController.currentPlayer}',
                  style: Get.textTheme.headlineMedium,
                )),
                const Text('Your current score is:'),
                Obx(() => Text(
                  '${gameController.scores}',
                  style: Get.textTheme.headlineMedium,
                )),
                Obx(() => Text(
                  'Next player is ${gameController.nextPlayer}'
                )),
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
              onPressed: () => gameController.rollDice(player: "Red"),
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
              onPressed: () => gameController.rollDice(player: "Green"),
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
              onPressed: () => gameController.rollDice(player: "Blue"),
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
              onPressed: () => gameController.rollDice(player: "Yellow"),
              tooltip: 'Roll dice (1 to 6)',
              child: const Icon(Icons.casino),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 93,
            child: FloatingActionButton(
              heroTag: 'btn5',
              backgroundColor: Colors.blueGrey,
              onPressed: gameController.moveFirstPawn,
              tooltip: 'Move pawn',
              child: const Icon(Icons.directions_walk),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 154,
            child: FloatingActionButton(
              heroTag: 'btn6',
              backgroundColor: Colors.blueGrey,
              onPressed: gameController.moveSecondPawn,
              tooltip: 'Move pawn',
              child: const Icon(Icons.directions_walk),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 215,
            child: FloatingActionButton(
              heroTag: 'btn7',
              backgroundColor: Colors.blueGrey,
              onPressed: gameController.moveThirdPawn,
              tooltip: 'Move pawn',
              child: const Icon(Icons.directions_walk),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 276,
            child: FloatingActionButton(
              heroTag: 'btn8',
              backgroundColor: Colors.blueGrey,
              onPressed: gameController.moveFourthPawn,
              tooltip: 'Move pawn',
              child: const Icon(Icons.directions_walk),
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

          Positioned(top: t, left: l, child: BoardSquare(index: 15, color: Colors.red.shade100)),
          const Positioned(top: t - s * 1, left: l, child: BoardSquare(index: 16)),
          const Positioned(top: t - s * 1, left: l + s * 1, child: BoardSquare(index: 17, color: Colors.red)),
          const Positioned(top: t - s * 1, left: l + s * 2, child: BoardSquare(index: 18)),
          const Positioned(top: t - s * 1, left: l + s * 3, child: BoardSquare(index: 19)),
          const Positioned(top: t - s * 1, left: l + s * 4, child: BoardSquare(index: 20)),
          const Positioned(top: t - s * 1, left: l + s * 5, child: BoardSquare(index: 21)),
          //
          const Positioned(top: t - s * 2, left: l + s * 6, child: BoardSquare(index: 22)),
          const Positioned(top: t - s * 3, left: l + s * 6, child: BoardSquare(index: 23)),
          const Positioned(top: t - s * 4, left: l + s * 6, child: BoardSquare(index: 24)),
          const Positioned(top: t - s * 5, left: l + s * 6, child: BoardSquare(index: 25, color: Colors.black38)),
          const Positioned(top: t - s * 6, left: l + s * 6, child: BoardSquare(index: 26)),
          const Positioned(top: t - s * 7, left: l + s * 6, child: BoardSquare(index: 27)),
          //
          Positioned(top: t - s * 7, left: l + s * 7, child: BoardSquare(index: 28, color: Colors.green.shade100)),
          const Positioned(top: t - s * 7, left: l + s * 8, child: BoardSquare(index: 29)),
          const Positioned(top: t - s * 6, left: l + s * 8, child: BoardSquare(index: 30, color: Colors.green)),
          const Positioned(top: t - s * 5, left: l + s * 8, child: BoardSquare(index: 31)),
          const Positioned(top: t - s * 4, left: l + s * 8, child: BoardSquare(index: 32)),
          const Positioned(top: t - s * 3, left: l + s * 8, child: BoardSquare(index: 33)),
          const Positioned(top: t - s * 2, left: l + s * 8, child: BoardSquare(index: 34)),
          //
          const Positioned(top: t - s * 1, left: l + s * 9, child: BoardSquare(index: 35)),
          const Positioned(top: t - s * 1, left: l + s * 10, child: BoardSquare(index: 36)),
          const Positioned(top: t - s * 1, left: l + s * 11, child: BoardSquare(index: 37)),
          const Positioned(top: t - s * 1, left: l + s * 12, child: BoardSquare(index: 38, color: Colors.black38)),
          const Positioned(top: t - s * 1, left: l + s * 13, child: BoardSquare(index: 39)),
          const Positioned(top: t - s * 1, left: l + s * 14, child: BoardSquare(index: 40)),
          Positioned(top: t - s * 0, left: l + s * 14, child: BoardSquare(index: 41, color: Colors.yellow.shade100)),
          //
          const Positioned(top: t + s * 1, left: l + s * 14, child: BoardSquare(index: 42)),
          const Positioned(top: t + s * 1, left: l + s * 13, child: BoardSquare(index: 43, color: Colors.yellow)),
          const Positioned(top: t + s * 1, left: l + s * 12, child: BoardSquare(index: 44)),
          const Positioned(top: t + s * 1, left: l + s * 11, child: BoardSquare(index: 45)),
          const Positioned(top: t + s * 1, left: l + s * 10, child: BoardSquare(index: 46)),
          const Positioned(top: t + s * 1, left: l + s * 9, child: BoardSquare(index: 47)),
          //
          const Positioned(top: t + s * 2, left: l + s * 8, child: BoardSquare(index: 48)),
          const Positioned(top: t + s * 3, left: l + s * 8, child: BoardSquare(index: 49)),
          const Positioned(top: t + s * 4, left: l + s * 8, child: BoardSquare(index: 50)),
          const Positioned(top: t + s * 5, left: l + s * 8, child: BoardSquare(index: 51, color: Colors.black38)),
          const Positioned(top: t + s * 6, left: l + s * 8, child: BoardSquare(index: 52)),
          //
          const Positioned(top: t + s * 7, left: l + s * 8, child: BoardSquare(index: 53)),
          Positioned(top: t + s * 7, left: l + s * 7, child: BoardSquare(index: 54, color: Colors.blue.shade100)),
          const Positioned(top: t + s * 7, left: l + s * 6, child: BoardSquare(index: 55)),
          //
          const Positioned(top: t + s * 6, left: l + s * 6, child: BoardSquare(index: 4, color: Colors.blue)),
          const Positioned(top: t + s * 5, left: l + s * 6, child: BoardSquare(index: 5)),
          const Positioned(top: t + s * 4, left: l + s * 6, child: BoardSquare(index: 6)),
          const Positioned(top: t + s * 3, left: l + s * 6, child: BoardSquare(index: 7)),
          const Positioned(top: t + s * 2, left: l + s * 6, child: BoardSquare(index: 8)),
          //
          const Positioned(top: t + s * 1, left: l + s * 5, child: BoardSquare(index: 9)),
          const Positioned(top: t + s * 1, left: l + s * 4, child: BoardSquare(index: 10)),
          const Positioned(top: t + s * 1, left: l + s * 3, child: BoardSquare(index: 11)),
          const Positioned(top: t + s * 1, left: l + s * 2, child: BoardSquare(index: 12, color: Colors.black38)),
          const Positioned(top: t + s * 1, left: l + s * 1, child: BoardSquare(index: 13)),
          const Positioned(top: t + s * 1, left: l + s * 0, child: BoardSquare(index: 14)),
          //
          Positioned(top: t + s * 6, left: l + s * 7, child: BoardSquare(index: 56, color: Colors.blue.shade200)),
          Positioned(top: t + s * 5, left: l + s * 7, child: BoardSquare(index: 57, color: Colors.blue.shade200)),
          Positioned(top: t + s * 4, left: l + s * 7, child: BoardSquare(index: 58, color: Colors.blue.shade200)),
          Positioned(top: t + s * 3, left: l + s * 7, child: BoardSquare(index: 59, color: Colors.blue.shade200)),
          Positioned(top: t + s * 2, left: l + s * 7, child: BoardSquare(index: 60, color: Colors.blue.shade200)),
          const Positioned(top: t + s * 1, left: l + s * 7, child: BoardSquare(index: 61, color: Colors.blue)),
          //
          Positioned(top: t + s * 0, left: l + s * 1, child: BoardSquare(index: 62, color: Colors.red.shade200)),
          Positioned(top: t + s * 0, left: l + s * 2, child: BoardSquare(index: 63, color: Colors.red.shade200)),
          Positioned(top: t + s * 0, left: l + s * 3, child: BoardSquare(index: 64, color: Colors.red.shade200)),
          Positioned(top: t + s * 0, left: l + s * 4, child: BoardSquare(index: 65, color: Colors.red.shade200)),
          Positioned(top: t + s * 0, left: l + s * 5, child: BoardSquare(index: 66, color: Colors.red.shade200)),
          const Positioned(top: t + s * 0, left: l + s * 6, child: BoardSquare(index: 67, color: Colors.red)),
          //
          Positioned(top: t - s * 6, left: l + s * 7, child: BoardSquare(index: 68, color: Colors.green.shade200)),
          Positioned(top: t - s * 5, left: l + s * 7, child: BoardSquare(index: 69, color: Colors.green.shade200)),
          Positioned(top: t - s * 4, left: l + s * 7, child: BoardSquare(index: 70, color: Colors.green.shade200)),
          Positioned(top: t - s * 3, left: l + s * 7, child: BoardSquare(index: 71, color: Colors.green.shade200)),
          Positioned(top: t - s * 2, left: l + s * 7, child: BoardSquare(index: 72, color: Colors.green.shade200)),
          const Positioned(top: t - s * 1, left: l + s * 7, child: BoardSquare(index: 73, color: Colors.green)),
          //
          Positioned(top: t + s * 0, left: l + s * 13, child: BoardSquare(index: 74, color: Colors.yellow.shade200)),
          Positioned(top: t + s * 0, left: l + s * 12, child: BoardSquare(index: 75, color: Colors.yellow.shade200)),
          Positioned(top: t + s * 0, left: l + s * 11, child: BoardSquare(index: 76, color: Colors.yellow.shade200)),
          Positioned(top: t + s * 0, left: l + s * 10, child: BoardSquare(index: 77, color: Colors.yellow.shade200)),
          Positioned(top: t + s * 0, left: l + s * 9, child: BoardSquare(index: 78, color: Colors.yellow.shade200)),
          const Positioned(top: t + s * 0, left: l + s * 8, child: BoardSquare(index: 79, color: Colors.yellow)),
          //
          const Positioned(top: t + s * 8, left: l + s * 1, child: BoardSquare(index: 0)),
          const Positioned(bottom: t + s * 8, left: l + s * 3, child: BoardSquare(index: 1)),
          const Positioned(bottom: t + s * 8, right: l + s * 3, child: BoardSquare(index: 2)),
          const Positioned(top: t + s * 8, right: l + s * 1, child: BoardSquare(index: 3)),


        ],
      ),
    );
  }
}
