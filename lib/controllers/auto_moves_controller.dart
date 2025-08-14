import 'dart:math';

import 'package:get/get.dart';
import '../models/fields.dart';
import '../models/players.dart';
import 'game_page_controller.dart';

class AutoMovesController extends GetxController {

  static int? moveIfOnlyOnePossibility(GamePageController gpc, int cpv, int dice) {
    List<(int index, int move)> possMoves = [];

    for (int i = 0; i < 4; i++) {
      int position = gpc.positionPawns[4 * cpv + i];
      int move = gpc.whereToGo(position, dice, cpv);
      if (position != move) {
        possMoves.add((i, move));
      }
    }

    if (possMoves.isEmpty) return null;

    final firstMove = possMoves.first.$2;
    final allSame = possMoves.every((e) => e.$2 == firstMove);

    if (allSame) {
      int r = Random().nextInt(possMoves.length);
      return possMoves[r].$1;
    }
    return null;
  }

  static int? thinkAboutGoOut(GamePageController gpc, int cpv, int dice) {
    if (dice != 6) {
      return null;
    }
    int r = Random().nextInt(4);
    int pow = gpc.tenPow(cpv);
    if (((gpc.board[cpv] + gpc.board[6 * cpv + 61]) ~/ pow) > r) {
      List<int> valuesSix = [0, 1, 2, 3];
      valuesSix.shuffle(Random());
      for (int value in valuesSix) {
        if (gpc.positionPawns[4 * cpv + value] == 13 * cpv + 4) {
          return value;
        }
      }
    }
    return null;
  }

  static int? thinkAboutBestMove(GamePageController gpc, int cpv, int dice) {
    int? goOut = thinkAboutGoOut(gpc, cpv, dice);
    if (goOut != null) {
      return goOut;
    }
    int pow = gpc.tenPow(cpv);
    List<int> possMoves = List.filled(4, -1);
    for (int i = 0; i < 4; i++) {
      possMoves[i] = gpc.whereToGo(gpc.positionPawns[4 * cpv + i], dice, cpv);
    }
    List<int> values = [];
    for (int value = 0; value < 4; value++) {
      if (possMoves[value] != gpc.positionPawns[4 * cpv + value]) {
        values.add(value);
      }
    }
    values.shuffle(Random());
    int? capture = checkCapture(values, gpc, possMoves, pow);
    if (capture != null) {
      return capture;
    }
    int? corridor = checkCorridor(values, gpc, possMoves, cpv, pow);
    if (corridor != null) {
      return corridor;
    }
    int? finish = checkFinishFields(values, possMoves);
    if (finish != null) {
      return finish;
    }
    int? safe = checkSafeFields(values, possMoves);
    if (safe != null) {
      return safe;
    }
    int? stay = checkPositions(values, gpc, cpv, Field.safeIndexes);
    if (stay != null) {
      return stay;
    }
    int? rest = checkPossibilityMoves(values, gpc, possMoves, cpv);
    if (rest != null) {
      return rest;
    }

    return null;
  }

  static int? checkCapture(List<int> values, GamePageController gpc, List<int> possMoves, int pow) {
    for (int value in values) {
      if (gpc.canCapture(possMoves[value], pow)) {
        return value;
      }
    }
    return null;
  }

  static int? checkCorridor(List<int> values, GamePageController gpc, List<int> possMoves, int cpv, int pow) {
    for (int value in values) {
      if (possMoves[value] > Field.yellow12.index && gpc.positionPawns[4 * cpv + value] < Field.blueCorridor1.index) {
        return value;
      }
    }
    return null;
  }

  static int? checkFields(List<int> values, List<int> possMoves, List<int> fields) {
    for (int value in values) {
      if (fields.contains(possMoves[value])) {
        return value;
      }
    }
    return null;
  }

  static int? checkPositions(List<int> values, GamePageController gpc, int cpv, List<int> fields) {
    for (int value in values) {
      if (!fields.contains(gpc.positionPawns[4 * cpv + value])) {
        return value;
      }
    }
    return null;
  }

  static int? checkPossibilityMoves(List<int> values, GamePageController gpc, List<int> possMoves, int cpv) {
    for (int value in values) {
      if (possMoves[value] != gpc.positionPawns[4 * cpv + value]) {
        return value;
      }
    }
    return null;
  }

  static int? checkFinishFields(List<int> values, List<int> possMoves) => checkFields(values, possMoves, Field.finishIndexes);
  static int? checkSafeFields(List<int> values, List<int> possMoves) => checkFields(values, possMoves, Field.safeIndexes);
}