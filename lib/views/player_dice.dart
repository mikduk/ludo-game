import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/game_page_controller.dart';
import '../controllers/screen_controller.dart';

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
                            : gameController.rollDicePlayer(player: player),
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
