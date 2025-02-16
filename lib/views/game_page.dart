import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_page_controller.dart';
import '../controllers/screen_controller.dart';
import 'board.dart';
import 'player_dice.dart';
import 'score_board.dart';

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
      GetBuilder<ScreenController>(
        builder: (screenController) {
          double topPosition = screenController.getBottomMargin() +
              screenController.screenHeight * 0.01;
          double leftPosition = screenController.screenWidth * 0.05;
          double buttonWidth = screenController.screenWidth * 0.9;

          return Positioned(
            bottom: topPosition,
            left: leftPosition,
            child: SizedBox(
              width: buttonWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (screenController.isPortrait)
                    ScoreBoard(gameController: gameController),
                ],
              ),
            ),
          );
        },
      ),
      GetBuilder<ScreenController>(builder: (screenController) {
        double x = (screenController.horizontalScoreBoard()) ? 0.03 : 0.08;
        double topPosition = screenController.screenHeight * (0.36 - x);
        double buttonWidth = screenController.getButtonWidth();

        return Positioned(
            top: topPosition,
            right: screenController.getRightScoreBoardPosition(),
            child: SizedBox(
                width: buttonWidth,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!screenController.isPortrait)
                        ScoreBoard(gameController: gameController),
                    ])));
      }),
      GetBuilder<ScreenController>(builder: (screenController) {
        return Padding(
            padding:
                EdgeInsets.only(top: screenController.getBoardTopPadding()),
            child: SizedBox(
              width: screenController.getBoardWidth(),
              height: screenController.getBoardHeight(),
              child: Stack(
                children: [
                  Board(
                      height: screenController.getBoardHeight(),
                      width: screenController.screenWidth,
                      fieldSize: screenController.getFieldSize())
                ],
              ),
            ));
      }),
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
                        width: screenController.getTopButtonsWidth(),
                        child: screenController.getBoardWidth() >= 600
                            ? _buildSingleRowLayout(
                                gameController, screenController)
                            : _buildTwoByTwoLayout(
                                gameController, screenController)),
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
              screenController.screenHeight * 0.02;
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
                                width: screenController.getBoardHeight() >= 600
                                    ? 0.04 * Get.width
                                    : null,
                                child: screenController.getBoardHeight() >= 600
                                    ? _buildSingleColumnLayout(
                                        gameController, screenController)
                                    : _buildTwoByTwoLayout(
                                        gameController, screenController))),
                    ])));
      }),
    ]));
  }

  Widget _buildSingleColumnLayout(
      GamePageController gameController, ScreenController screenController) {
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

  Widget _buildSingleRowLayout(
      GamePageController gameController, ScreenController screenController) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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

  Widget _buildTwoByTwoLayout(
      GamePageController gameController, ScreenController screenController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pierwszy wiersz (2 przyciski)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChangeModeButton(gameController: gameController),
            SizedBox(width: screenController.getWidthTwoByTwo()),
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
        SizedBox(height: screenController.getHeightTwoByTwo()),

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
            SizedBox(width: screenController.getWidthTwoByTwo()),
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
