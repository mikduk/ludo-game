import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/game_page_controller.dart';
import '../../controllers/screen_controller.dart';
import '../pawn_base.dart';

class BaseSquare extends StatelessWidget {
  final int index;
  final double size;
  final Color? color;

  const BaseSquare({super.key, required this.index, required this.size, this.color});

  @override
  Widget build(BuildContext context) {
    final GamePageController controller = Get.find<GamePageController>();

    return Obx(() => InkWell(
        onTap: () => fieldAction(controller),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              color: color ?? Colors.grey.shade100, border: Border.all()),
          child: Center(
            child: PawnBase(
              letter: showPawn(controller.positionPawns[index]),
              currentPlayer: controller.currentPlayer.value,
              waitForMove: controller.waitForMove.value && controller.score.value == 6 && !controller.bots[controller.getCurrentPlayer()],
            ),
          ),
        )));
  }

  double? getSize(int result) {
    final ScreenController controller = Get.find<ScreenController>();
    double ratio = controller.getFieldSize() / 29;
    switch (result) {
      case 0:
      case 1:
      case 2:
      case 3:
        return 12 * ratio;
      default:
        return 6 * ratio;
    }
  }

  Future<void> fieldAction(GamePageController controller) async {
    if (controller.bots[controller.currentPlayer.value]) {
      return;
    }
    if (controller.positionPawns[index] >= 4) {
      return;
    }
    controller.printForLogs('|base_squared| [fieldAction] controller.movePawn(pawnNumber: ${index % 4})');
    await controller.movePawn(pawnNumber: index % 4);
  }

  String showPawn(int field) {
    try {
      if (field > 3) {
        return '';
      }
      List<String> names = ['B', 'R', 'G', 'Y'];
      return names[index ~/ 4];
    } catch (e) {
      print(e);
      return 'E';
    }
  }
}
