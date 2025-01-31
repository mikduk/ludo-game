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
      SizedBox(
        width: screenController.getBoardWidth(),
        height: screenController.getBoardHeight(),
        child: Stack(
          children: [
            GetBuilder<ScreenController>(builder: (screenController) {
              return Board(
                  height: screenController.getBoardHeight(),
                  width: screenController.screenWidth,
                  fieldSize: screenController.getFieldSize());
            })
          ],
        ),
      ),
      // Przycisk w lewym górnym rogu
      GetBuilder<ScreenController>(
        builder: (screenController) {
          double topPosition = screenController.getTopMargin() +
              screenController.screenHeight * 0.03;
          double leftPosition = screenController.screenWidth * 0.05;
          double buttonWidth = screenController.screenWidth * 0.9;

          return Positioned(
            top: topPosition,
            left: leftPosition,
            child: SizedBox(
              width: buttonWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(
                      width: Get.width * 0.5,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        FloatingActionButton(
                          heroTag: 'btn9',
                          mini: true,
                          backgroundColor: Colors.tealAccent,
                          onPressed: gameController.showBoard,
                          tooltip: 'Show info',
                          child: const Icon(Icons.info),
                        ),
                        FloatingActionButton(
                          heroTag: 'btn10',
                          mini: true,
                          backgroundColor: Colors.lightBlueAccent,
                          onPressed: gameController.regenerateBoard,
                          tooltip: 'Regenerate board',
                          child: const Icon(Icons.refresh),
                        ),
                        FloatingActionButton(
                          heroTag: 'btn11',
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
                        FloatingActionButton(
                          heroTag: 'btn12',
                          mini: true,
                          backgroundColor: Colors.deepOrangeAccent,
                          onPressed: gameController.startStopGame,
                          tooltip: 'Start/stop game',
                          child: Obx(() => gameController.stopGame.value
                              ? const Icon(Icons.pause)
                              : const Icon(Icons.play_arrow)),
                        ),
                      ])),
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

    ]));
  }
}

class Board extends StatelessWidget {
  const Board(
      {super.key,
      required this.height,
      required this.width,
      required this.fieldSize});

  final double height;
  final double width;
  final double fieldSize;

  @override
  Widget build(BuildContext context) {
    double s = fieldSize;
    double t = s * 7;
    const double l = 4;

    return Padding(
        padding: EdgeInsets.only(
          top: (3 / 110) * height,
          bottom: (7 / 110) * height,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: t - s * 1,
              left: l + s * 6,
              child: DiagonalSquare(
                size: s + 1,
                color1: Colors.green,
                color2: Colors.red,
                isTopLeftToBottomRight: false,
              ),
            ),
            Positioned(
              top: t + s * 1,
              left: l + s * 6,
              child: DiagonalSquare(
                size: s + 1,
                color1: Colors.red,
                color2: Colors.blue,
                isTopLeftToBottomRight: true,
              ),
            ),
            Positioned(
              top: t - s * 1,
              left: l + s * 8,
              child: DiagonalSquare(
                size: s + 1,
                color1: Colors.green,
                color2: Colors.yellow,
                isTopLeftToBottomRight: true,
              ),
            ),
            Positioned(
              top: t + s * 1,
              left: l + s * 8,
              child: DiagonalSquare(
                size: s + 1,
                color1: Colors.yellow,
                color2: Colors.blue,
                isTopLeftToBottomRight: false,
              ),
            ),
            Positioned(
              top: t + s * 0,
              left: l + s * 7,
              child: FourColorSquare(
                size: s + 1,
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
                child: BoardSquare(
                    index: 15, size: s + 1, color: Colors.red.shade100)),
            Positioned(
                top: t - s * 1,
                left: l,
                child: BoardSquare(index: 16, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 1,
                child: BoardSquare(index: 17, size: s + 1, color: Colors.red)),
            Positioned(
                top: t - s * 1,
                left: l + s * 2,
                child: BoardSquare(index: 18, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 3,
                child: BoardSquare(index: 19, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 4,
                child: BoardSquare(index: 20, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 5,
                child: BoardSquare(index: 21, size: s + 1)),
            //
            Positioned(
                top: t - s * 2,
                left: l + s * 6,
                child: BoardSquare(index: 22, size: s + 1)),
            Positioned(
                top: t - s * 3,
                left: l + s * 6,
                child: BoardSquare(index: 23, size: s + 1)),
            Positioned(
                top: t - s * 4,
                left: l + s * 6,
                child: BoardSquare(index: 24, size: s + 1)),
            Positioned(
                top: t - s * 5,
                left: l + s * 6,
                child:
                    BoardSquare(index: 25, size: s + 1, color: Colors.black38)),
            Positioned(
                top: t - s * 6,
                left: l + s * 6,
                child: BoardSquare(index: 26, size: s + 1)),
            Positioned(
                top: t - s * 7,
                left: l + s * 6,
                child: BoardSquare(index: 27, size: s + 1)),
            //
            Positioned(
                top: t - s * 7,
                left: l + s * 7,
                child: BoardSquare(
                    index: 28, size: s + 1, color: Colors.green.shade100)),
            Positioned(
                top: t - s * 7,
                left: l + s * 8,
                child: BoardSquare(index: 29, size: s + 1)),
            Positioned(
                top: t - s * 6,
                left: l + s * 8,
                child:
                    BoardSquare(index: 30, size: s + 1, color: Colors.green)),
            Positioned(
                top: t - s * 5,
                left: l + s * 8,
                child: BoardSquare(index: 31, size: s + 1)),
            Positioned(
                top: t - s * 4,
                left: l + s * 8,
                child: BoardSquare(index: 32, size: s + 1)),
            Positioned(
                top: t - s * 3,
                left: l + s * 8,
                child: BoardSquare(index: 33, size: s + 1)),
            Positioned(
                top: t - s * 2,
                left: l + s * 8,
                child: BoardSquare(index: 34, size: s + 1)),
            //
            Positioned(
                top: t - s * 1,
                left: l + s * 9,
                child: BoardSquare(index: 35, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 10,
                child: BoardSquare(index: 36, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 11,
                child: BoardSquare(index: 37, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 12,
                child:
                    BoardSquare(index: 38, size: s + 1, color: Colors.black38)),
            Positioned(
                top: t - s * 1,
                left: l + s * 13,
                child: BoardSquare(index: 39, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 14,
                child: BoardSquare(index: 40, size: s + 1)),
            Positioned(
                top: t - s * 0,
                left: l + s * 14,
                child: BoardSquare(
                    index: 41, size: s + 1, color: Colors.yellow.shade100)),
            //
            Positioned(
                top: t + s * 1,
                left: l + s * 14,
                child: BoardSquare(index: 42, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 13,
                child:
                    BoardSquare(index: 43, size: s + 1, color: Colors.yellow)),
            Positioned(
                top: t + s * 1,
                left: l + s * 12,
                child: BoardSquare(index: 44, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 11,
                child: BoardSquare(index: 45, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 10,
                child: BoardSquare(index: 46, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 9,
                child: BoardSquare(index: 47, size: s + 1)),
            //
            Positioned(
                top: t + s * 2,
                left: l + s * 8,
                child: BoardSquare(index: 48, size: s + 1)),
            Positioned(
                top: t + s * 3,
                left: l + s * 8,
                child: BoardSquare(index: 49, size: s + 1)),
            Positioned(
                top: t + s * 4,
                left: l + s * 8,
                child: BoardSquare(index: 50, size: s + 1)),
            Positioned(
                top: t + s * 5,
                left: l + s * 8,
                child:
                    BoardSquare(index: 51, size: s + 1, color: Colors.black38)),
            Positioned(
                top: t + s * 6,
                left: l + s * 8,
                child: BoardSquare(index: 52, size: s + 1)),
            //
            Positioned(
                top: t + s * 7,
                left: l + s * 8,
                child: BoardSquare(index: 53, size: s + 1)),
            Positioned(
                top: t + s * 7,
                left: l + s * 7,
                child: BoardSquare(
                    index: 54, size: s + 1, color: Colors.blue.shade100)),
            Positioned(
                top: t + s * 7,
                left: l + s * 6,
                child: BoardSquare(index: 55, size: s + 1)),
            //
            Positioned(
                top: t + s * 6,
                left: l + s * 6,
                child: BoardSquare(index: 4, size: s + 1, color: Colors.blue)),
            Positioned(
                top: t + s * 5,
                left: l + s * 6,
                child: BoardSquare(index: 5, size: s + 1)),
            Positioned(
                top: t + s * 4,
                left: l + s * 6,
                child: BoardSquare(index: 6, size: s + 1)),
            Positioned(
                top: t + s * 3,
                left: l + s * 6,
                child: BoardSquare(index: 7, size: s + 1)),
            Positioned(
                top: t + s * 2,
                left: l + s * 6,
                child: BoardSquare(index: 8, size: s + 1)),
            //
            Positioned(
                top: t + s * 1,
                left: l + s * 5,
                child: BoardSquare(index: 9, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 4,
                child: BoardSquare(index: 10, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 3,
                child: BoardSquare(index: 11, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 2,
                child:
                    BoardSquare(index: 12, size: s + 1, color: Colors.black38)),
            Positioned(
                top: t + s * 1,
                left: l + s * 1,
                child: BoardSquare(index: 13, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 0,
                child: BoardSquare(index: 14, size: s + 1)),
            //
            Positioned(
                top: t + s * 6,
                left: l + s * 7,
                child: BoardSquare(
                    index: 56, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 5,
                left: l + s * 7,
                child: BoardSquare(
                    index: 57, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 4,
                left: l + s * 7,
                child: BoardSquare(
                    index: 58, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 3,
                left: l + s * 7,
                child: BoardSquare(
                    index: 59, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 1,
                left: l + s * 7,
                child: BoardSquare(
                    index: 61, size: s + 1, color: Colors.blue, border: false)),
            Positioned(
                top: t + s * 2,
                left: l + s * 7,
                child: BoardSquare(
                    index: 60, size: s + 1, color: Colors.blue.shade200)),
            //
            Positioned(
                top: t + s * 0,
                left: l + s * 1,
                child: BoardSquare(
                    index: 62, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t + s * 0,
                left: l + s * 2,
                child: BoardSquare(
                    index: 63, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t + s * 0,
                left: l + s * 3,
                child: BoardSquare(
                    index: 64, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t + s * 0,
                left: l + s * 4,
                child: BoardSquare(
                    index: 65, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t + s * 0,
                left: l + s * 6,
                child: BoardSquare(
                    index: 67, size: s + 1, color: Colors.red, border: false)),
            Positioned(
                top: t + s * 0,
                left: l + s * 5,
                child: BoardSquare(
                    index: 66, size: s + 1, color: Colors.red.shade200)),
            //
            Positioned(
                top: t - s * 6,
                left: l + s * 7,
                child: BoardSquare(
                    index: 68, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 5,
                left: l + s * 7,
                child: BoardSquare(
                    index: 69, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 4,
                left: l + s * 7,
                child: BoardSquare(
                    index: 70, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 3,
                left: l + s * 7,
                child: BoardSquare(
                    index: 71, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 1,
                left: l + s * 7,
                child: BoardSquare(
                    index: 73,
                    size: s + 1,
                    color: Colors.green,
                    border: false)),
            Positioned(
                top: t - s * 2,
                left: l + s * 7,
                child: BoardSquare(
                    index: 72, size: s + 1, color: Colors.green.shade200)),
            //
            Positioned(
                top: t + s * 0,
                left: l + s * 13,
                child: BoardSquare(
                    index: 74, size: s + 1, color: Colors.yellow.shade200)),
            Positioned(
                top: t + s * 0,
                left: l + s * 12,
                child: BoardSquare(
                    index: 75, size: s + 1, color: Colors.yellow.shade200)),
            Positioned(
                top: t + s * 0,
                left: l + s * 11,
                child: BoardSquare(
                    index: 76, size: s + 1, color: Colors.yellow.shade300)),
            Positioned(
                top: t + s * 0,
                left: l + s * 10,
                child: BoardSquare(
                    index: 77, size: s + 1, color: Colors.yellow.shade300)),
            Positioned(
                top: t + s * 0,
                left: l + s * 8,
                child: BoardSquare(
                    index: 79,
                    size: s + 1,
                    color: Colors.yellow,
                    border: false)),
            Positioned(
                top: t + s * 0,
                left: l + s * 9,
                child: BoardSquare(
                    index: 78, size: s + 1, color: Colors.yellow.shade400)),
            //
            Positioned(
                top: t + s * 5.5,
                left: l + s * 3,
                child: BaseSquare(
                    index: 0, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 5.5,
                left: l + s * 4,
                child: BaseSquare(
                    index: 1, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 6.5,
                left: l + s * 3,
                child: BaseSquare(
                    index: 2, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 6.5,
                left: l + s * 4,
                child: BaseSquare(
                    index: 3, size: s + 1, color: Colors.blue.shade200)),
            //
            Positioned(
                top: t - s * 4,
                left: l + s * 0.5,
                child: BaseSquare(
                    index: 4, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t - s * 4,
                left: l + s * 1.5,
                child: BaseSquare(
                    index: 5, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t - s * 3,
                left: l + s * 0.5,
                child: BaseSquare(
                    index: 6, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t - s * 3,
                left: l + s * 1.5,
                child: BaseSquare(
                    index: 7, size: s + 1, color: Colors.red.shade200)),
            //
            Positioned(
                top: t - s * 6.5,
                left: l + s * 10,
                child: BaseSquare(
                    index: 8, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 6.5,
                left: l + s * 11,
                child: BaseSquare(
                    index: 9, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 5.5,
                left: l + s * 10,
                child: BaseSquare(
                    index: 10, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 5.5,
                left: l + s * 11,
                child: BaseSquare(
                    index: 11, size: s + 1, color: Colors.green.shade200)),
            //
            Positioned(
                top: t + s * 3,
                left: l + s * 12.5,
                child: BaseSquare(
                    index: 12, size: s + 1, color: Colors.yellow.shade200)),
            Positioned(
                top: t + s * 3,
                left: l + s * 13.5,
                child: BaseSquare(
                    index: 13, size: s + 1, color: Colors.yellow.shade200)),
            Positioned(
                top: t + s * 4,
                left: l + s * 12.5,
                child: BaseSquare(
                    index: 14, size: s + 1, color: Colors.yellow.shade200)),
            Positioned(
                top: t + s * 4,
                left: l + s * 13.5,
                child: BaseSquare(
                    index: 15, size: s + 1, color: Colors.yellow.shade200)),
          ],
        ));
  }
}
