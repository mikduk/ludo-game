import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/screen_controller.dart';
import '../controllers/team_setup_controller.dart';
import '../models/game_modes.dart';
import '/views/game_page.dart';

class TeamSetupPage extends StatelessWidget {
  TeamSetupPage({super.key});

  final ScreenController screenController = Get.find<ScreenController>();
  final TeamSetupController teamSetupController =
      Get.put(TeamSetupController());

  @override
  Widget build(BuildContext context) {
    screenController.onReady();
    return GetBuilder<ScreenController>(
      builder: (c) {
        final shortest = min(c.screenHeight, c.screenWidth) * 0.828;

        return Scaffold(
          backgroundColor: Colors.white,
          body: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: shortest * 0.08 +
                                0.25 * (c.screenHeight - shortest),
                            bottom: 0.25 * (c.screenHeight - shortest)),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _text('select_game_mode'.tr),
                              SizedBox(height: shortest * 0.02),
                              ModeSelector(
                                size: shortest * 0.3,
                                opacity: 1.0,
                                controller: teamSetupController,
                              ),
                              SizedBox(height: shortest * 0.01),
                              Obx(() {
                                final mode = teamSetupController.teamWork.value
                                    ? GameModes.cooperation
                                    : GameModes.classic;

                                return Text(mode.name.tr);
                              }),
                              SizedBox(height: shortest * 0.08),
                              _text('select_player_type'.tr),
                              // PRZED buttonem _menuButton
                              SizedBox(height: shortest * 0.02),
                              c.screenWidth > c.screenHeight
                                  ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DogSelector(
                                    size: shortest * 0.3,
                                    opacity: 1.0,
                                    player: 0,
                                    controller: teamSetupController,
                                  ),
                                  SizedBox(width: shortest * 0.02),
                                  DogSelector(
                                    size: shortest * 0.3,
                                    opacity: 1.0,
                                    player: 1,
                                    controller: teamSetupController,
                                  ),
                                  SizedBox(width: shortest * 0.02),
                                  DogSelector(
                                    size: shortest * 0.3,
                                    opacity: 1.0,
                                    player: 2,
                                    controller: teamSetupController,
                                  ),
                                  SizedBox(width: shortest * 0.02),
                                  DogSelector(
                                    size: shortest * 0.3,
                                    opacity: 1.0,
                                    player: 3,
                                    controller: teamSetupController,
                                  ),
                                ],
                              )
                                  : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DogSelector(
                                        size: shortest * 0.3,
                                        opacity: 1.0,
                                        player: 1,
                                        controller: teamSetupController,
                                      ),
                                      SizedBox(width: shortest * 0.02),
                                      DogSelector(
                                        size: shortest * 0.3,
                                        opacity: 1.0,
                                        player: 2,
                                        controller: teamSetupController,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: shortest * 0.02),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DogSelector(
                                        size: shortest * 0.3,
                                        opacity: 1.0,
                                        player: 0,
                                        controller: teamSetupController,
                                      ),
                                      SizedBox(width: shortest * 0.02),
                                      DogSelector(
                                        size: shortest * 0.3,
                                        opacity: 1.0,
                                        player: 3,
                                        controller: teamSetupController,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: shortest * 0.06),
                              _menuButton(
                                text: 'start_game'.tr,
                                onPressed: () =>
                                    Get.off(() =>
                                        GamePage(
                                            namesOfPlayers: teamSetupController
                                                .colors,
                                            valuesOfBots: teamSetupController
                                                .bots,
                                            gameMode:
                                            teamSetupController.getGameMode())),
                                shortest: min(c.screenHeight, c.screenWidth),
                                c: c,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Text _text(String text) =>
      Text(text, style: const TextStyle(fontWeight: FontWeight.bold));

  Widget _menuButton({
    required String text,
    required VoidCallback? onPressed,
    required double shortest,
    required ScreenController c,
  }) {
    double width = min(shortest * 0.72, c.screenHeight * 0.52);
    double height = max(shortest * 0.085, c.screenHeight * 0.07);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: c.screenWidth * 0.1,
          vertical: c.screenHeight * 0.02,
        ),
        fixedSize: Size(width, height),
        textStyle: TextStyle(fontSize: min(shortest * 0.04, 20)),
      ),
      child: Text(text),
    );
  }
}

class ModeSelector extends StatelessWidget {
  final double size;
  final double opacity;
  final TeamSetupController controller;

  const ModeSelector({
    super.key,
    required this.size,
    required this.opacity,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => controller.toggleTeamWork(),
        child: Obx(() {
          final mode = controller.teamWork.value
              ? GameModes.cooperation.name
              : GameModes.classic.name;
          final path = 'assets/images/modes/$mode.png';

          return Opacity(
            opacity: opacity,
            child: Image.asset(
              path,
              width: size * (1466 / 743),
              height: size,
              fit: BoxFit.contain,
            ),
          );
        }),
      ),
    );
  }
}

class DogSelector extends StatelessWidget {
  final double size;
  final double opacity;
  final int player;
  final TeamSetupController controller;

  const DogSelector({
    super.key,
    required this.size,
    required this.opacity,
    required this.player,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => controller.toggleBotForPlayer(player),
        child: Obx(() {
          final role = controller.bots[player] ? 'bot' : 'player';
          final path = 'assets/images/dogs/${player}_$role.png';

          return Opacity(
            opacity: opacity,
            child: Image.asset(
              path,
              width: size,
              height: size,
              fit: BoxFit.contain,
            ),
          );
        }),
      ),
    );
  }
}
