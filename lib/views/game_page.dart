import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_page_controller.dart';
import '../controllers/screen_controller.dart';
import 'squares/base_squared.dart';
import 'squares/board_squared.dart';
import 'squares/diagonal_squared.dart';
import 'squares/four_color_squared.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final GamePageController gameController = Get.put(GamePageController());
    final ScreenController screenController = Get.put(ScreenController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purple.shade50,
                Colors.purple.shade100,
                Colors.purple.shade50,
              ],
              stops: const [0.1, 0.8, 0.9], // Płynniejsze przejście
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
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
                  Obx(() => Text(
                      'Next player is ${gameController.colors[gameController.nextPlayer.value]}')),
                ],
              ),
            )),
        // Przycisk w lewym górnym rogu
        GetBuilder<ScreenController>(
          builder: (screenController) {
            double topPosition = screenController.screenHeight * 0.03;
            double leftPosition = screenController.screenWidth * 0.05;
            double buttonWidth = screenController.screenWidth * 0.9;

            return Positioned(
              top: topPosition,
              left: leftPosition,
              child: SizedBox(
                width: buttonWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        // Obx wewnątrz GetBuilder dla dynamicznych zmian
                        Obx(() => FloatingActionButton(
                          heroTag: 'btn1',
                          backgroundColor: gameController.bots[1]
                              ? Colors.grey.shade400
                              : Colors.red,
                          onPressed: () => gameController.bots[1]
                              ? null
                              : gameController.rollDice(player: 1),
                          tooltip: 'Roll dice (1 to 6)',
                          child: Icon(Icons.casino,
                              color: gameController.bots[1]
                                  ? Colors.grey.shade700
                                  : null),
                        )),
                        Obx(() => Switch(
                          activeTrackColor: Colors.red,
                          value: gameController.bots[1],
                          onChanged: (bool value) {
                            gameController.changeBotFlag(1);
                          },
                        )),
                      ],
                    ),
                    Column(
                      children: [
                        // Obx wewnątrz GetBuilder dla dynamicznych zmian
                        Obx(() => FloatingActionButton(
                          heroTag: 'btn2',
                          backgroundColor: gameController.bots[2]
                              ? Colors.grey.shade400
                              : Colors.green,
                          onPressed: () => gameController.bots[2]
                              ? null
                              : gameController.rollDice(player: 2),
                          tooltip: 'Roll dice (1 to 6)',
                          child: Icon(Icons.casino,
                              color: gameController.bots[2]
                                  ? Colors.grey.shade700
                                  : null),
                        )),
                        Obx(() => Switch(
                          activeTrackColor: Colors.green,
                          value: gameController.bots[2],
                          onChanged: (bool value) {
                            gameController.changeBotFlag(2);
                          },
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Positioned(
            bottom: 150,
            left: 30,
            child: Column(
              children: [
                Obx(() => Switch(
                    activeTrackColor: Colors.blue,
                    value: gameController.bots[0],
                    onChanged: (bool value) {
                      gameController.changeBotFlag(0);
                    })),
                Obx(() => FloatingActionButton(
                    heroTag: 'btn0',
                    backgroundColor: gameController.bots[0]
                        ? Colors.grey.shade400
                        : Colors.blue,
                    onPressed: () => gameController.bots[0]
                        ? null
                        : gameController.rollDice(player: 0),
                    tooltip: 'Roll dice (1 to 6)',
                    child: Icon(Icons.casino,
                        color: gameController.bots[0]
                            ? Colors.grey.shade700
                            : null))),
              ],
            )),
        Positioned(
            bottom: 150,
            right: 30,
            child: Column(
              children: [
                Obx(() => Switch(
                    activeTrackColor: Colors.yellow,
                    value: gameController.bots[3],
                    onChanged: (bool value) {
                      gameController.changeBotFlag(3);
                    })),
                Obx(() => FloatingActionButton(
                    heroTag: 'btn3',
                    backgroundColor: gameController.bots[3]
                        ? Colors.grey.shade400
                        : Colors.yellow,
                    onPressed: () => gameController.bots[3]
                        ? null
                        : gameController.rollDice(player: 3),
                    tooltip: 'Roll dice (1 to 6)',
                    child: Icon(Icons.casino,
                        color: gameController.bots[3]
                            ? Colors.grey.shade700
                            : null))),
              ],
            )),
        Positioned(
          top: 12,
          left: 116,
          child: FloatingActionButton(
            heroTag: 'btn9',
            mini: true,
            backgroundColor: Colors.tealAccent,
            onPressed: gameController.showBoard,
            tooltip: 'Show info',
            child: const Icon(Icons.info),
          ),
        ),
        Positioned(
          top: 12,
          left: 166,
          child: FloatingActionButton(
            heroTag: 'btn10',
            mini: true,
            backgroundColor: Colors.amber,
            onPressed: gameController.endTurn,
            tooltip: 'End of turn',
            child: const Icon(Icons.hourglass_empty),
          ),
        ),
        Positioned(
          top: 12,
          left: 216,
          child: FloatingActionButton(
            heroTag: 'btn11',
            mini: true,
            backgroundColor: Colors.lightBlueAccent,
            onPressed: gameController.regenerateBoard,
            tooltip: 'Regenerate board',
            child: const Icon(Icons.refresh),
          ),
        ),
        Positioned(
          top: 12,
          left: 266,
          child: FloatingActionButton(
            heroTag: 'btn12',
            mini: true,
            backgroundColor: Colors.limeAccent,
            onPressed: () {
              gameController.soundSwitch();
              gameController.playRandomSound();
            },
            tooltip: 'Switch sound',
            child: Obx(() => gameController.soundOn.value
                ? const Icon(Icons.music_note_outlined)
                : const Icon(Icons.music_off_outlined)),
          ),
        ),
        Positioned(
          top: 66,
          left: 188,
          child: FloatingActionButton(
            heroTag: 'btn13',
            mini: true,
            backgroundColor: Colors.deepOrangeAccent,
            onPressed: gameController.startStopGame,
            tooltip: 'Start/stop game',
            child: Obx(() => gameController.stopGame.value
                ? const Icon(Icons.pause)
                : const Icon(Icons.play_arrow)),
          ),
        ),
        Container(
          width: min(Get.width, Get.height),
          height: min(Get.width, Get.height),
          // color: Colors.blueGrey,
          child: const Stack(
            children: [
              Board(),
            ],
          ),
        ),
      ]),
    );
  }
}

class Board extends StatelessWidget {
  const Board({super.key});

  final double s = 29 - 1;
  final double t = (29 - 1) * 7;
  final double l = 3;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: t - s * 1,
          left: l + s * 6,
          child: const DiagonalSquare(
            color1: Colors.green,
            color2: Colors.red,
            isTopLeftToBottomRight: false,
          ),
        ),
        Positioned(
          top: t + s * 1,
          left: l + s * 6,
          child: const DiagonalSquare(
            color1: Colors.red,
            color2: Colors.blue,
            isTopLeftToBottomRight: true,
          ),
        ),
        Positioned(
          top: t - s * 1,
          left: l + s * 8,
          child: const DiagonalSquare(
            color1: Colors.green,
            color2: Colors.yellow,
            isTopLeftToBottomRight: true,
          ),
        ),
        Positioned(
          top: t + s * 1,
          left: l + s * 8,
          child: const DiagonalSquare(
            color1: Colors.yellow,
            color2: Colors.blue,
            isTopLeftToBottomRight: false,
          ),
        ),
        Positioned(
          top: t + s * 0,
          left: l + s * 7,
          child: const FourColorSquare(
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
            top: t,
            left: l,
            child: BoardSquare(index: 15, color: Colors.red.shade100)),
        Positioned(
            top: t - s * 1, left: l, child: const BoardSquare(index: 16)),
        Positioned(
            top: t - s * 1,
            left: l + s * 1,
            child: const BoardSquare(index: 17, color: Colors.red)),
        Positioned(
            top: t - s * 1,
            left: l + s * 2,
            child: const BoardSquare(index: 18)),
        Positioned(
            top: t - s * 1,
            left: l + s * 3,
            child: const BoardSquare(index: 19)),
        Positioned(
            top: t - s * 1,
            left: l + s * 4,
            child: const BoardSquare(index: 20)),
        Positioned(
            top: t - s * 1,
            left: l + s * 5,
            child: const BoardSquare(index: 21)),
        //
        Positioned(
            top: t - s * 2,
            left: l + s * 6,
            child: const BoardSquare(index: 22)),
        Positioned(
            top: t - s * 3,
            left: l + s * 6,
            child: const BoardSquare(index: 23)),
        Positioned(
            top: t - s * 4,
            left: l + s * 6,
            child: const BoardSquare(index: 24)),
        Positioned(
            top: t - s * 5,
            left: l + s * 6,
            child: const BoardSquare(index: 25, color: Colors.black38)),
        Positioned(
            top: t - s * 6,
            left: l + s * 6,
            child: const BoardSquare(index: 26)),
        Positioned(
            top: t - s * 7,
            left: l + s * 6,
            child: const BoardSquare(index: 27)),
        //
        Positioned(
            top: t - s * 7,
            left: l + s * 7,
            child: BoardSquare(index: 28, color: Colors.green.shade100)),
        Positioned(
            top: t - s * 7,
            left: l + s * 8,
            child: const BoardSquare(index: 29)),
        Positioned(
            top: t - s * 6,
            left: l + s * 8,
            child: const BoardSquare(index: 30, color: Colors.green)),
        Positioned(
            top: t - s * 5,
            left: l + s * 8,
            child: const BoardSquare(index: 31)),
        Positioned(
            top: t - s * 4,
            left: l + s * 8,
            child: const BoardSquare(index: 32)),
        Positioned(
            top: t - s * 3,
            left: l + s * 8,
            child: const BoardSquare(index: 33)),
        Positioned(
            top: t - s * 2,
            left: l + s * 8,
            child: const BoardSquare(index: 34)),
        //
        Positioned(
            top: t - s * 1,
            left: l + s * 9,
            child: const BoardSquare(index: 35)),
        Positioned(
            top: t - s * 1,
            left: l + s * 10,
            child: const BoardSquare(index: 36)),
        Positioned(
            top: t - s * 1,
            left: l + s * 11,
            child: const BoardSquare(index: 37)),
        Positioned(
            top: t - s * 1,
            left: l + s * 12,
            child: const BoardSquare(index: 38, color: Colors.black38)),
        Positioned(
            top: t - s * 1,
            left: l + s * 13,
            child: const BoardSquare(index: 39)),
        Positioned(
            top: t - s * 1,
            left: l + s * 14,
            child: const BoardSquare(index: 40)),
        Positioned(
            top: t - s * 0,
            left: l + s * 14,
            child: BoardSquare(index: 41, color: Colors.yellow.shade100)),
        //
        Positioned(
            top: t + s * 1,
            left: l + s * 14,
            child: const BoardSquare(index: 42)),
        Positioned(
            top: t + s * 1,
            left: l + s * 13,
            child: const BoardSquare(index: 43, color: Colors.yellow)),
        Positioned(
            top: t + s * 1,
            left: l + s * 12,
            child: const BoardSquare(index: 44)),
        Positioned(
            top: t + s * 1,
            left: l + s * 11,
            child: const BoardSquare(index: 45)),
        Positioned(
            top: t + s * 1,
            left: l + s * 10,
            child: const BoardSquare(index: 46)),
        Positioned(
            top: t + s * 1,
            left: l + s * 9,
            child: const BoardSquare(index: 47)),
        //
        Positioned(
            top: t + s * 2,
            left: l + s * 8,
            child: const BoardSquare(index: 48)),
        Positioned(
            top: t + s * 3,
            left: l + s * 8,
            child: const BoardSquare(index: 49)),
        Positioned(
            top: t + s * 4,
            left: l + s * 8,
            child: const BoardSquare(index: 50)),
        Positioned(
            top: t + s * 5,
            left: l + s * 8,
            child: const BoardSquare(index: 51, color: Colors.black38)),
        Positioned(
            top: t + s * 6,
            left: l + s * 8,
            child: const BoardSquare(index: 52)),
        //
        Positioned(
            top: t + s * 7,
            left: l + s * 8,
            child: const BoardSquare(index: 53)),
        Positioned(
            top: t + s * 7,
            left: l + s * 7,
            child: BoardSquare(index: 54, color: Colors.blue.shade100)),
        Positioned(
            top: t + s * 7,
            left: l + s * 6,
            child: const BoardSquare(index: 55)),
        //
        Positioned(
            top: t + s * 6,
            left: l + s * 6,
            child: const BoardSquare(index: 4, color: Colors.blue)),
        Positioned(
            top: t + s * 5,
            left: l + s * 6,
            child: const BoardSquare(index: 5)),
        Positioned(
            top: t + s * 4,
            left: l + s * 6,
            child: const BoardSquare(index: 6)),
        Positioned(
            top: t + s * 3,
            left: l + s * 6,
            child: const BoardSquare(index: 7)),
        Positioned(
            top: t + s * 2,
            left: l + s * 6,
            child: const BoardSquare(index: 8)),
        //
        Positioned(
            top: t + s * 1,
            left: l + s * 5,
            child: const BoardSquare(index: 9)),
        Positioned(
            top: t + s * 1,
            left: l + s * 4,
            child: const BoardSquare(index: 10)),
        Positioned(
            top: t + s * 1,
            left: l + s * 3,
            child: const BoardSquare(index: 11)),
        Positioned(
            top: t + s * 1,
            left: l + s * 2,
            child: const BoardSquare(index: 12, color: Colors.black38)),
        Positioned(
            top: t + s * 1,
            left: l + s * 1,
            child: const BoardSquare(index: 13)),
        Positioned(
            top: t + s * 1,
            left: l + s * 0,
            child: const BoardSquare(index: 14)),
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
        Positioned(
            top: t + s * 1,
            left: l + s * 7,
            child: const BoardSquare(
                index: 61, color: Colors.blue, border: false)),
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
        Positioned(
            top: t + s * 0,
            left: l + s * 6,
            child:
                const BoardSquare(index: 67, color: Colors.red, border: false)),
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
        Positioned(
            top: t - s * 1,
            left: l + s * 7,
            child: const BoardSquare(
                index: 73, color: Colors.green, border: false)),
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
        Positioned(
            top: t + s * 0,
            left: l + s * 8,
            child: const BoardSquare(
                index: 79, color: Colors.yellow, border: false)),
        Positioned(
            top: t + s * 0,
            left: l + s * 9,
            child: BoardSquare(index: 78, color: Colors.yellow.shade400)),
        //
        Positioned(
            top: t + s * 5.5,
            left: l + s * 3,
            child: BaseSquare(index: 0, color: Colors.blue.shade200)),
        Positioned(
            top: t + s * 5.5,
            left: l + s * 4,
            child: BaseSquare(index: 1, color: Colors.blue.shade200)),
        Positioned(
            top: t + s * 6.5,
            left: l + s * 3,
            child: BaseSquare(index: 2, color: Colors.blue.shade200)),
        Positioned(
            top: t + s * 6.5,
            left: l + s * 4,
            child: BaseSquare(index: 3, color: Colors.blue.shade200)),
        //
        Positioned(
            top: t - s * 4,
            left: l + s * 0.5,
            child: BaseSquare(index: 4, color: Colors.red.shade200)),
        Positioned(
            top: t - s * 4,
            left: l + s * 1.5,
            child: BaseSquare(index: 5, color: Colors.red.shade200)),
        Positioned(
            top: t - s * 3,
            left: l + s * 0.5,
            child: BaseSquare(index: 6, color: Colors.red.shade200)),
        Positioned(
            top: t - s * 3,
            left: l + s * 1.5,
            child: BaseSquare(index: 7, color: Colors.red.shade200)),
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
            top: t + s * 3,
            left: l + s * 12.5,
            child: BaseSquare(index: 12, color: Colors.yellow.shade200)),
        Positioned(
            top: t + s * 3,
            left: l + s * 13.5,
            child: BaseSquare(index: 13, color: Colors.yellow.shade200)),
        Positioned(
            top: t + s * 4,
            left: l + s * 12.5,
            child: BaseSquare(index: 14, color: Colors.yellow.shade200)),
        Positioned(
            top: t + s * 4,
            left: l + s * 13.5,
            child: BaseSquare(index: 15, color: Colors.yellow.shade200)),
      ],
    );
  }
}
