import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_page_controller.dart';
import '../controllers/screen_controller.dart';
import 'score_board.dart';
import 'squares/base_squared.dart';
import 'squares/board_squared.dart';
import 'squares/diagonal_squared.dart';
import 'squares/four_color_squared.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

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
                  PlayerDice(
                      player: 1,
                      color: Colors.red,
                      gameController: gameController),
                  if (screenController.isPortrait)
                    SizedBox(
                        width: Get.width * 0.45,
                        child: screenController.getBoardWidth() >= 600 ?  _buildSingleRowLayout(gameController, screenController) : _buildTwoByTwoLayout(gameController, screenController)
                    ),
                  PlayerDice(
                      player: 2,
                      color: Colors.green,
                      gameController: gameController),
                ],
              ),
            ),
          );
        },
      ),
      GetBuilder<ScreenController>(
        builder: (screenController) {
          double topPosition = screenController.getBottomMargin() +
              screenController.screenHeight * 0.002;
          double leftPosition = screenController.screenWidth * 0.05;
          double buttonWidth = screenController.screenWidth * 0.9;

          return Positioned(
            bottom: topPosition,
            left: leftPosition,
            child: SizedBox(
              width: buttonWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlayerDice(
                      player: 0,
                      color: Colors.blue,
                      gameController: gameController),
                  if (screenController.isPortrait)
                    ScoreBoard(gameController: gameController),
                  PlayerDice(
                      player: 3,
                      color: Colors.yellow,
                      gameController: gameController),
                ],
              ),
            ),
          );
        },
      ),
      GetBuilder<ScreenController>(builder: (screenController) {
        double x = (screenController.horizontalScoreBoard()) ? 0.03 : 0.08;
        double topPosition = screenController.screenHeight * (0.36 - x);
        double topPadding = screenController.screenHeight * x;
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
                      if (!screenController.isPortrait)
                        Padding(
                            padding: EdgeInsets.only(top: topPadding),
                            child: SizedBox(
                                width: screenController.getBoardHeight() >= 600 ? 0.04 * Get.width : null,
                                child: screenController.getBoardHeight() >= 600
                                    ? _buildSingleColumnLayout(gameController, screenController)
                                    : _buildTwoByTwoLayout(gameController, screenController))),
                      if (!screenController.isPortrait)
                        ScoreBoard(gameController: gameController),
                    ])));
      })
    ]));
  }

  Widget _buildSingleColumnLayout(GamePageController gameController, ScreenController screenController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChangeModeButton(gameController: gameController),
        FloatingActionButton(
          heroTag: 'btn10',
          mini: true,
          backgroundColor: Colors.lightBlueAccent,
          onPressed: () {
            gameController.regenerateBoard();
            screenController.update();
          },
          tooltip: 'Regenerate board',
          child: const Icon(Icons.refresh),
        ),
        FloatingActionButton(
          heroTag: 'btn11',
          mini: true,
          backgroundColor: Colors.limeAccent,
          onPressed: gameController.soundSwitch,
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
      ],
    );
  }

  Widget _buildSingleRowLayout(GamePageController gameController, ScreenController screenController) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChangeModeButton(gameController: gameController),
          FloatingActionButton(
            heroTag: 'btn10',
            mini: true,
            backgroundColor: Colors.lightBlueAccent,
            onPressed: () {
              gameController.regenerateBoard();
              screenController.update();
            },
            tooltip: 'Regenerate board',
            child: const Icon(Icons.refresh),
          ),
          FloatingActionButton(
            heroTag: 'btn11',
            mini: true,
            backgroundColor: Colors.limeAccent,
            onPressed: gameController.soundSwitch,
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
        ]);
  }

  Widget _buildTwoByTwoLayout(GamePageController gameController, ScreenController screenController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pierwszy wiersz (2 przyciski)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChangeModeButton(gameController: gameController),
            const SizedBox(width: 8),
            FloatingActionButton(
              heroTag: 'btn10',
              mini: true,
              backgroundColor: Colors.lightBlueAccent,
              onPressed: () {
    gameController.regenerateBoard();
    screenController.update();
    },
              tooltip: 'Regenerate board',
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Drugi wiersz (2 przyciski)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: 'btn11',
              mini: true,
              backgroundColor: Colors.limeAccent,
              onPressed: gameController.soundSwitch,
              tooltip: 'Switch sound',
              child: Obx(() => gameController.soundOn.value
                  ? const Icon(Icons.music_note_outlined)
                  : const Icon(Icons.music_off_outlined)),
            ),
            const SizedBox(width: 8),
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
          ],
        ),
      ],
    );
  }
}

class ChangeModeButton extends StatelessWidget {
  const ChangeModeButton({
    super.key,
    required this.gameController,
  });

  final GamePageController gameController;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'btn9',
      mini: true,
      backgroundColor: Colors.tealAccent,
      onPressed: gameController.changeMode,
      tooltip: 'Change mode',
      child: Obx(() => gameController.teamWork.value
          ? const Icon(Icons.people)
          : const Icon(Icons.person)),
    );
  }
}

class PlayerDice extends StatelessWidget {
  const PlayerDice({
    super.key,
    required this.player,
    required this.color,
    required this.gameController,
  });

  final int player;
  final Color color;
  final GamePageController gameController;

  @override
  Widget build(BuildContext context) {
    final ScreenController controller = Get.find<ScreenController>();
    bool shortVersion = controller.screenWidth < 600.0;
    return Column(
      crossAxisAlignment: shortVersion
          ? (player >= 2 ? CrossAxisAlignment.end : CrossAxisAlignment.start)
          : CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.only(
                left: player >= 2 ? 0 : 5, right: player >= 2 ? 5 : 0),
            child: Obx(() =>
                Stack(alignment: AlignmentDirectional.bottomEnd, children: [
                  Padding(
                      padding:
                          const EdgeInsets.only(bottom: 2, right: 20, left: 0),
                      child: FloatingActionButton(
                        heroTag: 'btn$player',
                        backgroundColor: gameController.bots[player]
                            ? Colors.grey.shade400
                            : color,
                        onPressed: () => gameController.bots[player]
                            ? null
                            : gameController.rollDice(player: player),
                        tooltip: 'Roll dice (1 to 6)',
                        child: Icon(
                          Icons.casino,
                          color: gameController.bots[player]
                              ? Colors.grey.shade700
                              : null,
                        ),
                      )),
                  InkWell(
                      onLongPress: () {
                        gameController.autoMovesSwitch(player);
                      },
                      child: SizedBox(
                          height: 20,
                          width: 20,
                          // color: Colors.deepOrangeAccent[100],
                          child: Icon(
                              gameController.autoMoves[player]
                                  ? Icons.directions_run_outlined
                                  : Icons.touch_app_sharp,
                              color: Colors.black38)))
                ]))),
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!shortVersion || player >= 2)
                  Icon(
                      (shortVersion && gameController.bots[player])
                          ? Icons.smartphone_rounded
                          : Icons.person,
                      color: (!shortVersion && gameController.bots[player])
                          ? Colors.grey.shade500
                          : Colors.black),
                if (!shortVersion || player >= 2) const SizedBox(width: 2),
                Switch(
                  activeTrackColor: color,
                  value: gameController.bots[player],
                  onChanged: (bool value) {
                    gameController.changeBotFlag(player);
                  },
                ),
                if (!shortVersion || player < 2) const SizedBox(width: 2),
                if (!shortVersion || player < 2)
                  Icon(
                      (shortVersion && !gameController.bots[player])
                          ? Icons.person
                          : Icons.smartphone_rounded,
                      color: (!shortVersion && !gameController.bots[player])
                          ? Colors.grey.shade500
                          : Colors.black),
              ],
            )),
      ],
    );
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
    double l = (height > width) ? (width - fieldSize * 15) * 0.5 : 0;

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
