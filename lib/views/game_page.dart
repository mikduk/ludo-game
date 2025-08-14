import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_page_controller.dart';
import '../controllers/screen_controller.dart';
import '../models/game_modes.dart';
import 'board.dart';
import 'expandable_gear_menu.dart';
import 'score_board.dart';

class GamePage extends StatelessWidget {
  final List<String>? namesOfPlayers;
  final List<bool>? valuesOfBots;
  final GameModes? gameMode;
  final bool testMode;

  const GamePage({
    super.key,
    this.namesOfPlayers,
    this.valuesOfBots,
    this.gameMode,
    this.testMode = false
  })  : assert(
          (namesOfPlayers == null &&
                  valuesOfBots == null &&
                  gameMode == null) ||
              (namesOfPlayers != null &&
                  valuesOfBots != null &&
                  gameMode != null),
          'params error',
        );

  @override
  Widget build(BuildContext context) {
    final GamePageController gameController =
    namesOfPlayers != null
    ? Get.put(GamePageController(
        namesOfPlayers: namesOfPlayers!,
        valuesOfBots: valuesOfBots!,
        gameMode: gameMode!,
        testMode: testMode))
    : Get.put(GamePageController(clearOnLoad: false));
    final ScreenController screenController = Get.find();

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
        double x = (screenController.horizontalScoreBoard()) ? 0.03 : 0.3;
        double topPosition = screenController.screenHeight * (0.36 - x);
        double buttonWidth = screenController.getButtonWidth();

        return Positioned(
            // top: topPosition,
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
          double buttonWidth = screenController.screenWidth * 0.94;

          return Positioned(
            top: topPosition,
            left: leftPosition,
            child: SizedBox(
              width: buttonWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PlayerDice(
                  //     player: 1,
                  //     color: Colors.red,
                  //     gameController: gameController),
                  if (screenController.isPortrait)
                    SizedBox(
                        width: screenController.getTopButtonsWidth(),
                        child: Container()),
                  // PlayerDice(
                  //     player: 2,
                  //     color: Colors.green,
                  //     gameController: gameController),
                  ExpandableGameMenu(
                    gameController: gameController,
                    screenController: screenController,
                  ),
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
                  // PlayerDice(
                  //     player: 0,
                  //     color: Colors.blue,
                  //     gameController: gameController),
                  // PlayerDice(
                  //     player: 3,
                  //     color: Colors.yellow,
                  //     gameController: gameController),
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
                                child: Container())),
                    ])));
      }),
    ]));
  }
}
