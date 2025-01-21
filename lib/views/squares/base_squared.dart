import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/game_page_controller.dart';

class BaseSquare extends StatelessWidget {
  final int index; // Indeks elementu board, który ma być wyświetlany
  final Color? color;

  const BaseSquare({super.key, required this.index, this.color});

  @override
  Widget build(BuildContext context) {
    final GamePageController controller = Get.find<GamePageController>();

    return Obx(() => InkWell(
        onTap: () => fieldAction(controller),
        child: Container(
          width: 29.0,
          height: 29.0,
          decoration: BoxDecoration(
              color: color ?? Colors.grey.shade100, border: Border.all()),
          child: Center(
            child: Text(
              showPawn(controller
                  .positionPawns[index]), // Wyświetla wartość board[index]
              style: TextStyle(
                fontSize: getSize(controller.positionPawns[index]),
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )));
  }

  double? getSize(int result) {
    switch (result) {
      case 0:
      case 1:
      case 2:
      case 3:
        return 12;
      default:
        return 6;
    }
  }

  Future<void> fieldAction(GamePageController controller) async {
    if (controller.positionPawns[index] >= 4) {
      return;
    }

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
