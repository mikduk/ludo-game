import 'package:flutter/material.dart';
import 'pawn_label.dart';

class PawnBase extends PawnLabel {
  PawnBase({
    super.key,
    required String letter,
    required super.currentPlayer,
    required super.waitForMove,
  }) : super(
    fieldValue: _computeFieldValue(letter),
  );

  static int _computeFieldValue(String letter) {
    final index = _mapLetterToPlayerIndex(letter.toUpperCase());
    if (index == null) return -1;

    final digits = List.filled(4, 0)..[3 - index] = 1;
    return int.parse(digits.join());
  }

  static int? _mapLetterToPlayerIndex(String letter) {
    switch (letter) {
      case 'B': return 0;
      case 'R': return 1;
      case 'G': return 2;
      case 'Y': return 3;
      default: return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fieldValue < 0) return const SizedBox.shrink();
    return super.build(context);
  }
}
