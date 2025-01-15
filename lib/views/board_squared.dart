import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_page_controller.dart';

class BoardSquare extends StatelessWidget {
  final int index; // Indeks elementu board, który ma być wyświetlany
  final Color? color;

  const BoardSquare({super.key, required this.index, this.color});

  @override
  Widget build(BuildContext context) {
    final GamePageController controller = Get.find<GamePageController>();

    return Obx(() => Container(
      width: 29.0,
      height: 29.0,
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade100,
        border: Border.all()
      ),
      child: Center(
        child: Text(
          showPawn(controller.board[index]), // Wyświetla wartość board[index]
          style: const TextStyle(
            fontSize: 6.0,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
  }

  String showPawn(int field){
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
