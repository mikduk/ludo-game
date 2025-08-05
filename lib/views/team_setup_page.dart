import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/screen_controller.dart';
import '../controllers/team_setup_controller.dart';
import '../models/game_modes.dart';
import '/views/game_page.dart';
import 'basic_page.dart';

class TeamSetupPage extends BasicPage {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _text('select_game_mode'.tr),
                    SizedBox(height: shortest * 0.02),
                    ModeSelector(
                      size: (c.screenHeight + shortest) * 0.15,
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
                                    size: shortest * 0.4,
                                    opacity: 1.0,
                                    player: 1,
                                    controller: teamSetupController,
                                  ),
                                  SizedBox(width: shortest * 0.02),
                                  DogSelector(
                                    size: shortest * 0.4,
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
                                    size: shortest * 0.4,
                                    opacity: 1.0,
                                    player: 0,
                                    controller: teamSetupController,
                                  ),
                                  SizedBox(width: shortest * 0.02),
                                  DogSelector(
                                    size: shortest * 0.4,
                                    opacity: 1.0,
                                    player: 3,
                                    controller: teamSetupController,
                                  ),
                                ],
                              ),
                            ],
                          ),

                    SizedBox(height: (2 * c.screenHeight - shortest) * 0.02),
                    menuButton(
                      text: 'start_game'.tr,
                      onPressed: () => Get.offAll(() => GamePage(
                          namesOfPlayers: teamSetupController.colors,
                          valuesOfBots: teamSetupController.bots,
                          gameMode: teamSetupController.getGameMode())),
                      shortest: min(c.screenHeight, c.screenWidth),
                      c: c,
                    ),
                    SizedBox(height: c.screenHeight * 0.02),
                  ],
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
