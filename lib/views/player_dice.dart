import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/game_page_controller.dart';

class PlayerDice extends StatelessWidget {
  const PlayerDice({
    super.key,
  });

  final List<Color> colors = const [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    final GamePageController gameController = Get.find();
    return Padding(
      padding: const EdgeInsets.only(bottom: 0, right: 0, left: 0),
      child: Obx(() {
        final int current = gameController.currentPlayer.value;
        final bool isBot = gameController.bots[current];

        return Stack(
          alignment: Alignment.bottomLeft,
          children: [
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: isBot
                  ? null
                  : () => gameController.rollDicePlayer(player: current),
              onLongPress:
                  isBot ? null : () => gameController.autoMovesSwitch(current),
              child: Padding(
                  padding: const EdgeInsets.only(left: 6, bottom: 10),
                  child: FloatingActionButton(
                    heroTag: 'btn$current',
                    backgroundColor:
                    (isBot || gameController.waitForMove.value) ? Colors.grey.shade400 : colors[current],
                    onPressed: null,
                    tooltip: null,
                    child: Icon(
                      Icons.casino,
                      color: isBot ? Colors.grey.shade700 : null,
                    ),
                  )),
            ),
            if (!isBot)
              InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  onTap: null,
                  onLongPress:
                  isBot ? null : () => gameController.autoMovesSwitch(current),
                  child:
              CircleAvatar(
                  radius: 12.5,
                  backgroundColor: Colors.white70,
                  child: Icon(
                      gameController.autoMoves[current]
                          ? Icons.directions_run_outlined
                          : Icons.touch_app_sharp,
                      color: Colors.black38))),
          ],
        );
      }),
    );
  }
}
