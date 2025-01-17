import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_page_controller.dart';

class BoardSquare extends StatelessWidget {
  final int index; // Indeks elementu board, który ma być wyświetlany
  final Color? color;
  final bool border;

  const BoardSquare({super.key, required this.index, this.color, this.border=true});

  @override
  Widget build(BuildContext context) {
    final GamePageController controller = Get.find<GamePageController>();

    return Obx(() => InkWell(
        onTap: () => fieldAction(controller),
        child: Container(
          width: 29.0,
          height: 29.0,
          decoration: BoxDecoration(
              color: color ?? Colors.grey.shade100, border: border ? Border.all() : null),
          child: Center(
            child: Text(
              showPawn(
                  controller.board[index]), // Wyświetla wartość board[index]
              style: TextStyle(
                fontSize: getSize(controller.board[index]),
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
        return null;
      case 1:
      case 10:
      case 100:
      case 1000:
        return 12;
      default:
        return 6;
    }
  }

  Future<void> fieldAction(GamePageController controller) async {
    print('fieldAction: $index, ==> [${controller.board[index]}]');
    int result = controller.board[index];
    if (result == 0) {
      return;
    }
    int currentPlayerIndex =
        controller.colors.indexOf(controller.currentPlayer.value);
    int foundPawn = -1;
    print('currentPlayerIndex: $currentPlayerIndex');
    for (int i = 0; i < 4; i++) {
      if (controller.positionPawns[4 * currentPlayerIndex + i] == index) {
        foundPawn = i;
        break;
      }
    }
    print('foundPawn: $foundPawn, ${controller.positionPawns}');
    if (foundPawn >= 0 && foundPawn <= 3) {
      await controller.movePawn(pawnNumber: foundPawn);
    }
  }

  String showPawn(int field) {
    try {
      if (field == 0) {
        return '';
      }
      String r = field.toString();
      String result = '';
      while (r.length < 4) {
        r = '0$r';
      }
      List<String> names = ['Y', 'G', 'R', 'B'];
      for (int ind = 0; ind <= 3; ind++) {
        if (r[ind] != '0') {
          for (int i = 0; i < int.parse(r[ind]); i++) {
            result += names[ind];
          }
        }
      }
      return result;
    } catch (e) {
      print(e);
      return 'E';
    }
  }
}
