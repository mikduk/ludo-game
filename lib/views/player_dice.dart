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

        return FloatingActionButton(
          heroTag: 'btn$current',
          backgroundColor: isBot ? Colors.grey.shade400 : colors[current],
          onPressed: isBot
              ? null
              : () => gameController.rollDicePlayer(player: current),
          tooltip: 'Roll dice (1 to 6)',
          child: Icon(
            Icons.casino,
            color: isBot ? Colors.grey.shade700 : null,
          ),
        );
      }),
    );
  }
}
