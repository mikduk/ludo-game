import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/game_page_controller.dart';
import '../../controllers/screen_controller.dart';

class BoardSquare extends StatelessWidget {
  final int index; // Indeks elementu board, który ma być wyświetlany
  final double size;
  final Color? color;
  final bool border;

  const BoardSquare({super.key, required this.index, required this.size, this.color, this.border=true});

  @override
  Widget build(BuildContext context) {
    final GamePageController controller = Get.find<GamePageController>();

    return Obx(() => InkWell(
        onTap: () => fieldAction(controller),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              color: (controller.waitForMove.value && isPossibleMove(controller)) ? Colors.lime : (color ?? Colors.grey.shade100), border: border ? Border.all() : null),
          child: Center(
            child: Text(
              showPawn(
                  controller.board[index],
                  controller.regenerateBoard
              ),
              style: TextStyle(
                fontSize: getSize(controller.board[index]),
                color: getColor(controller.board[index], controller.getCurrentPlayer()),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )));
  }

  double? getSize(int result) {
    final ScreenController controller = Get.find<ScreenController>();
    double ratio = controller.getFieldSize() / 29;
    switch (result) {
      case 0:
        return null;
      case 1:
      case 10:
      case 100:
      case 1000:
        return 12 * ratio;
      case 11:
      case 101:
      case 110:
      case 1001:
      case 1010:
      case 1100:
      case 2:
      case 20:
      case 200:
      case 2000:
        return 10.5 * ratio;
      default:
        return 9 * ratio;
    }
  }

  Color? getColor(int field, int activePlayerColor) {
    String fieldString = field.toString().padLeft(4, '0');
    if (fieldString[3-activePlayerColor] != '0') {
      return Colors.black;
    }
    return Colors.black54;
  }

  bool isPossibleMove(GamePageController controller) {
    int cpv = controller.getCurrentPlayer();
    if (controller.waitForMove.value && !controller.bots[controller.currentPlayer.value]) {
      List<int> possMoves = List.filled(4, -1);
      for (int i = 0; i < 4; i++) {
        int position = controller.positionPawns[4 * cpv + i];
        int move = controller.whereToGo(position, controller.score.value, cpv);
        possMoves[i] = (position != move) ? move : -1;
      }
      if (possMoves.contains(index)) {
        return true;
      }
    }
    return false;
  }

  Future<void> fieldAction(GamePageController controller) async {
    int result = controller.board[index];
    if (result == 0) {
      return;
    }
    int currentPlayerIndex = controller.getCurrentPlayer();
    int foundPawn = -1;
    for (int i = 0; i < 4; i++) {
      if (controller.positionPawns[4 * currentPlayerIndex + i] == index) {
        foundPawn = i;
        break;
      }
    }
    if (foundPawn >= 0 && foundPawn <= 3) {
      await controller.movePawn(pawnNumber: foundPawn);
    }
  }

  String showPawn(int field, Function()? regenerate) {
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
      print('|BOARD SQUARED| $e');
      Future.delayed(const Duration(seconds: 1), regenerate);
      return 'E';
    }
  }
}
