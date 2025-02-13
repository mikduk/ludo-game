import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/game_page_controller.dart';
import '../../controllers/screen_controller.dart';

class BoardSquare extends StatefulWidget {
  final int index;    // Indeks elementu board, który ma być wyświetlany
  final double size;
  final Color? color;
  final bool border;

  const BoardSquare({
    super.key,
    required this.index,
    required this.size,
    this.color,
    this.border = true,
  });

  @override
  State<BoardSquare> createState() => _BoardSquareState();
}

class _BoardSquareState extends State<BoardSquare> with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;

  // Flaga, która mówi, czy pole jest obecnie podświetlane
  bool _isHighlighted = false;

  @override
  void initState() {
    super.initState();
    // Kontroler animacji – 1 sekunda, potem powtarzamy w tę i z powrotem (reverse)
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 740),
    );

    // Kolor od (szary) do (zielony) – można zmienić na inne barwy
    _colorAnimation = ColorTween(
      begin: widget.color ?? Colors.grey.shade100,
      end: Colors.lime,
    ).animate(_blinkController);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GamePageController controller = Get.find<GamePageController>();

    // Obx – reagujemy na zmiany w kontrolerze (waitForMove, board, itp.)
    return Obx(() {
      // Sprawdzamy, czy należy migać polem
      final highlight = (controller.waitForMove.value && !controller.fieldActionFlag.value && isPossibleMove(controller));

      // Jeśli warunek się zmienił na "migaj"
      if (highlight && !_isHighlighted) {
        _isHighlighted = true;
        _blinkController.repeat(reverse: true);
      }
      // Jeśli warunek się zmienił na "nie migaj"
      else if (!highlight && _isHighlighted) {
        _isHighlighted = false;
        _blinkController.stop();
        _blinkController.reset();
      }

      // To jest bazowy kolor pola, gdy NIE jest highlightowane
      final Color baseColor = widget.color ?? Colors.grey.shade100;

      // AnimatedBuilder pozwala nam nasłuchiwać _blinkController i
      // na tej podstawie modyfikować color w Containerze
      return AnimatedBuilder(
        animation: _blinkController,
        builder: (context, child) {
          // Jeśli highlight = true, kolor przyjmie animowaną wartość
          // w przeciwnym razie zwykły "baseColor"
          final Color? color = highlight ? _colorAnimation.value : baseColor;

          return InkWell(
            onTap: () => fieldAction(controller),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: color,
                border: widget.border ? Border.all() : null,
              ),
              child: Center(
                child: Text(
                  showPawn(
                    controller.board[widget.index],
                    controller.regenerateBoard,
                  ),
                  style: TextStyle(
                    fontSize: getSize(controller.board[widget.index]),
                    color: getColor(controller.board[widget.index], controller.getCurrentPlayer()),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  // Sprawdza, czy ruch jest możliwy na to pole (Twoja oryginalna logika)
  bool isPossibleMove(GamePageController controller) {
    int cpv = controller.getCurrentPlayer();
    if (controller.waitForMove.value && !controller.bots[controller.currentPlayer.value]) {
      List<int> possMoves = List.filled(4, -1);
      for (int i = 0; i < 4; i++) {
        int position = controller.positionPawns[4 * cpv + i];
        int move = controller.whereToGo(position, controller.score.value, cpv);
        possMoves[i] = (position != move) ? move : -1;
      }
      if (possMoves.contains(widget.index)) {
        return true;
      }
    }
    return false;
  }

  // Obsługa kliknięcia na pole
  Future<void> fieldAction(GamePageController controller) async {
    int result = controller.board[widget.index];
    if (result == 0 || controller.fieldActionFlag.value) {
      return;
    }
    int currentPlayerIndex = controller.getCurrentPlayer();
    int foundPawn = -1;
    for (int i = 0; i < 4; i++) {
      if (controller.positionPawns[4 * currentPlayerIndex + i] == widget.index) {
        foundPawn = i;
        break;
      }
    }
    if (foundPawn >= 0 && foundPawn <= 3) {
      controller.setFieldActionFlag(value: true);
      await controller.movePawn(pawnNumber: foundPawn);
      controller.setFieldActionFlag(value: false);
    }
  }

  // Ustala wielkość czcionki w zależności od wartości w polu (Twoja oryginalna logika)
  double? getSize(int result) {
    final ScreenController screen = Get.find<ScreenController>();
    double ratio = screen.getFieldSize() / 29;
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

  // Ustala kolor tekstu pola (Twoja oryginalna logika)
  Color? getColor(int field, int activePlayerColor) {
    String fieldString = field.toString().padLeft(4, '0');
    if (fieldString[3 - activePlayerColor] != '0') {
      return Colors.black;
    }
    return Colors.black54;
  }

  // Tworzy oznaczenia pionków (Y, G, R, B) w zależności od wartości w polu (Twoja oryginalna logika)
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
      print('|BOARD SQUARE| $e');
      Future.delayed(const Duration(seconds: 1), regenerate);
      return 'E';
    }
  }
}
