import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/game_page_controller.dart';
import '../../models/fields.dart';
import '../pawn_label.dart';

class FinishSquare extends StatelessWidget {
  final Field field;
  final double size;
  final Color? color;
  final bool border;
  final bool borderHorizontal;
  final bool borderVertical;

  const FinishSquare(
      {super.key,
      required this.field,
      required this.size,
      this.color,
      this.border = true,
      this.borderHorizontal = true,
      this.borderVertical = true});

  @override
  Widget build(BuildContext context) {
    final GamePageController controller = Get.find<GamePageController>();
    return Obx(() {
          return InkWell(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
              ),
              child: Center(
                child: PawnLabel(
                  fieldValue: controller.board[field.index],
                  currentPlayer: controller.getCurrentPlayer(),
                  regenerate: controller.regenerateBoard,
                  waitForMove: false,
                  lastField: true
                ),
              ),
            ),
          );});
  }
}