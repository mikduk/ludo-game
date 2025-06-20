import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/game_page_controller.dart';
import '../../controllers/screen_controller.dart';
import '../pawn_label.dart';

class BoardSquare extends StatefulWidget {
  final int index; // Indeks elementu board, który ma być wyświetlany
  final double size;
  final Color? color;
  final bool border;
  final bool borderHorizontal;
  final bool borderVertical;

  const BoardSquare(
      {super.key,
      required this.index,
      required this.size,
      this.color,
      this.border = true,
      this.borderHorizontal = true,
      this.borderVertical = true});

  @override
  State<BoardSquare> createState() => _BoardSquareState();
}

class _BoardSquareState extends State<BoardSquare>
    with SingleTickerProviderStateMixin {
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
      final highlight = (controller.waitForMove.value &&
          !controller.fieldActionFlag.value &&
          isPossibleMove(controller));

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
                border: widget.border
                    ? Border.symmetric(
                        horizontal: widget.borderHorizontal
                            ? const BorderSide(width: 1, color: Colors.black)
                            : BorderSide.none,
                        vertical: widget.borderVertical
                            ? const BorderSide(width: 1, color: Colors.black)
                            : BorderSide.none,
                      )
                    : null,
              ),
              child: Center(
                child: PawnLabel(
                  fieldValue: controller.board[widget.index],
                  currentPlayer: controller.getCurrentPlayer(),
                  regenerate: controller.regenerateBoard,
                  waitForMove: controller.waitForMove.value && !controller.bots[controller.getCurrentPlayer()],
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
    if (controller.waitForMove.value &&
        !controller.bots[controller.currentPlayer.value]) {
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
    controller.printForLogs('|fieldAction| ${widget.index}');
    int currentPlayerIndex = controller.getCurrentPlayer();
    int foundPawn = -1;
    for (int i = 0; i < 4; i++) {
      if (controller.positionPawns[4 * currentPlayerIndex + i] ==
          widget.index) {
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

}