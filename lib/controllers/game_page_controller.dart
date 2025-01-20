import 'package:get/get.dart';
import 'dart:math';

class GamePageController extends GetxController {
  final List<String> colors = ['Blue', 'Red', 'Green', 'Yellow'];

  var score = 0.obs;
  var scores = ''.obs;
  var currentPlayer = 0.obs;
  var nextPlayer = 1.obs;
  var waitForMove = false.obs;
  var board = List.filled(80, 0).obs;
  var kills = 0.obs;
  var finished = 0.obs;
  bool showSnackbar = false;
  var positionPawns = List.filled(16, 0).obs;
  var bots = List.filled(4, false).obs;

  @override
  void onInit({bool test = false}) {
    super.onInit();
    if (test) {
      showSnackbar = true;
    }
    initializeBoard();
  }

  void initializeBoard() {
    board.value = List.filled(80, 0);
    currentPlayer.value = 0;
    nextPlayer.value = 1;
    waitForMove = false.obs;
    score = 0.obs;
    scores = ''.obs;

    board[0] = 4;
    board[1] = 40;
    board[2] = 400;
    board[3] = 4000;

    for (int i = 0; i < 16; i++) {
      positionPawns[i] = i ~/ 4;
    }

    /// TEST
    bots[0] = true;
    bots[1] = true;
    bots[2] = true;
    bots[3] = true;

    board[0] = 2;
    board[1] = 20;
    board[2] = 200;
    board[3] = 2000;
    board[61] = 2;
    board[67] = 20;
    board[73] = 200;
    board[79] = 2000;
    positionPawns[0] = 61;
    positionPawns[1] = 61;
    positionPawns[4] = 67;
    positionPawns[5] = 67;
    positionPawns[8] = 73;
    positionPawns[9] = 73;
    positionPawns[12] = 79;
    positionPawns[13] = 79;

  }

  @override
  void onReady() {
    super.onReady();
    print('Kontroler jest gotowy!');
  }

  @override
  void onClose() {
    print('Kontroler został zamknięty');
    super.onClose(); // Wywołanie domyślnej metody onClose()
  }

  Future<void> rollDice({int player = -1, int possibilities = 6}) async {
    print(
        '|rollDice| waitForMove: $waitForMove, currentPlayer: $currentPlayer, player: $player');
    if (waitForMove.value) {
      if (showSnackbar) {
        Get.snackbar('Uwaga', 'Wykonaj ruch pionka!',
            snackPosition: SnackPosition.BOTTOM);
      }
      return;
    }
    if (player == currentPlayer.value) {
      int value = Random().nextInt(possibilities) + (6 - possibilities) + 1;
      print('|rollDice| value: $value');
      score.value = value;
      scores.value += value.toString();

      await automaticallyMovePawn();
    }
  }

  void changeBotFlag(int player) {
    bots[player] = !bots[player];
  }

  Future<void> automaticallyMovePawn() async {
    if (everyoneInBaseOrFinish()) {
      if (score.value != 6) {
        await Future.delayed(const Duration(seconds: 1), getNextPlayer);
      } else {
        setWaitForMoveValue(true);
      }
    } else if (everyoneInBaseOrFinishOrCannotGo()) {
      await Future.delayed(const Duration(seconds: 1), getNextPlayer);
    } else if (scores.value.contains('666')) {
      await Future.delayed(const Duration(seconds: 2), getNextPlayer);
    } else {
      setWaitForMoveValue(true);
    }
  }

  bool everyoneInFinish({int? player}) {
    player ??= currentPlayer.value;
    int pow = tenPow(player);
    return (board[61 + player * 6] == 4 * pow);
  }

  bool everyoneInBaseOrFinish() {
    int pow = tenPow(currentPlayer.value);
    return (board[currentPlayer.value] + board[61 + currentPlayer.value * 6] ==
        4 * pow);
  }

  bool everyoneInBaseOrFinishOrCannotGo() {
    bool result = true;
    int cpv = currentPlayer.value;

    for (int i = 0; i < 4; i++) {
      int pawnField = positionPawns[4 * cpv + i];
      if (pawnField != cpv && (pawnField + score.value) <= (61 + cpv * 6)) {
        return false;
      }
    }
    return result;
  }

  Future<void> moveFirstPawn() async => await movePawn(pawnNumber: 0);
  Future<void> moveSecondPawn() async => await movePawn(pawnNumber: 1);
  Future<void> moveThirdPawn() async => await movePawn(pawnNumber: 2);
  Future<void> moveFourthPawn() async => await movePawn(pawnNumber: 3);

  Future<void> movePawn({int? pawnNumber}) async {
    print('|movePawn| waitForMove: $waitForMove');
    if (waitForMove.value) {
      try {
        print('|movePawn| LECIMY TUTAJ --> movePlayerPawn($pawnNumber)');
        await movePlayerPawn(pawnNumber);
        if (showSnackbar) {
          Get.snackbar('Tytuł', 'Ruch pionka wykonany!',
              snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        print('|movePawn| $e');
        if (showSnackbar) {
          Get.snackbar('Tytuł', 'Ruch tego pionka zabroniony!',
              snackPosition: SnackPosition.BOTTOM);
        }
        rethrow;
      }
    } else {
      if (showSnackbar) {
        Get.snackbar('Tytuł', 'Nie teraz byczku ;)',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void setWaitForMoveValue(bool value) {
    print('|setWaitForMoveValue| value: $value');
    waitForMove.value = value;
  }

  Future<void> movePlayerPawn(int? pawnNumber) async {
    int currentIndex = currentPlayer.value;
    int pow = tenPow(currentIndex);

    print('|movePlayerPawn| currentIndex: $currentIndex, pow: $pow');

    // Pierwszy ruch
    if (score.value == 6 &&
        positionPawns[4 * currentIndex + (pawnNumber ?? 0)] == currentIndex) {
      board[currentIndex] -= pow;
      int x = currentIndex * 13 + 4;
      await goToField(x, pow, pawnNumber ?? 0);
    } else if (positionPawns[4 * currentIndex + (pawnNumber ?? 0)] !=
        currentIndex) {
      int i = positionPawns[4 * currentIndex + (pawnNumber ?? 0)];
      board[i] -= pow;
      int x = whereToGo(i, score.value, currentIndex);
      await goToField(x, pow, pawnNumber ?? 0);
    } else {
      throw ArgumentError(
          'Pionek $pawnNumber. $currentPlayer nie może się ruszyć.');
    }
  }

  int whereToGo(int i, int n, int colorIndex) {
    print('|whereToGo| i: $i, n: $n, colorIndex: $colorIndex');
    if (i < 4) {
      if (n != 6) {
        return i;
      } else {
        return 13 * i + 4;
      }
    } else if (i >= 56 && i + n > 61 + 6 * colorIndex) {
      return i;
    }
    late int translatedI;
    if (i > 55) {
      translatedI = i - colorIndex * 6;
    } else {
      translatedI = i - colorIndex * 13;
    }
    if (translatedI < 4) {
      translatedI = i + (4 - colorIndex) * 13;
    }
    if (translatedI + n < 51 + 4) {
      translatedI += n;
    } else {
      print('|whereToGo| i: $i, translatedI: $translatedI');
      if (translatedI >= 56 && translatedI <= 61) {
        if (translatedI + n <= 61) {
          translatedI += n;
        }
      } else if (translatedI == 55) {
        print('ERROR - tu nie powinno być pionka: $i');
      } else if (translatedI >= 48 && translatedI <= 54) {
        translatedI += 1 + n;
      } else {
        translatedI += n;
      }
    }
    if (translatedI >= 56) {
      i = translatedI + colorIndex * 6;
    } else {
      i = translatedI + colorIndex * 13;
      if (i > 55) {
        i = i - 55 + 4 - 1;
      }
    }
    print('|whereToGo| ==> i: $i, translatedI: $translatedI');
    return i;
  }

  Future<void> goToField(int x, int pow, int pawnNumber) async {
    print('|goToField| x: $x, pow: $pow, pawnNumber: $pawnNumber');
    await goToFieldAnimate(positionPawns[4 * tenLog(pow) + pawnNumber], x, pow);
    if (board[x] == 0) {
      board[x] = pow;
    } else if (canCapture(x, pow)) {
      await capture(x, pow);
      board[x] = pow;
    } else {
      board[x] += pow;
    }
    positionPawns[4 * tenLog(pow) + pawnNumber] = x;
    if ([61, 67, 73, 79].contains(x)) {
      finished.value += 1;
    }
    await endTurn();
  }

  Future<void> goToFieldAnimate(int from, int to, int pow,
      {Duration delayTime = const Duration(milliseconds: 180)}) async {
    int originalPosition = to;
    if ([0, 1, 2, 3].contains(to)) {
      switch (to) {
        case 0:
          to = 4;
          break;
        case 1:
          to = 17;
          break;
        case 2:
          to = 30;
          break;
        case 3:
          to = 43;
          break;
      }
    }
    while (from != to) {
      if ((3 < from && to < 56 && to == originalPosition) ||
          (from >= 56 && to >= 56)) {
        from++;
        if (from > 55 && to < 56) {
          from = 4;
        }
        board[from] += pow;
      } else if (to >= 56) {
        from++;
        switch (from) {
          case 16:
            from = 62;
            break;
          case 29:
            from = 68;
            break;
          case 42:
            from = 74;
            break;
          case 55:
            from = 56;
            break;
        }
        board[from] += pow;
      } else if ([0, 1, 2, 3].contains(originalPosition)) {
        from--;
        if (from < 4) {
          from = 55;
        }
        board[from] += pow;
      } else {
        return;
      }
      await Future.delayed(delayTime);
      board[from] -= pow;
    }
  }

  bool canCapture(int x, int pow, {bool teamMode = false}) {
    List<int> safeFields = [4, 12, 17, 25, 30, 38, 43, 51];
    List<int> attackMoves = [1, 10, 100, 1000];
    int result = board[x];

    if (x < 4 || x > 55 || safeFields.contains(x)) {
      return false;
    } else if (attackMoves.contains(result) && pow != result) {
      // TODO
      return true;
    }
    return false;
  }

  Future<void> capture(int x, int pow) async {
    print('|capture| x: $x, pow: $pow');
    int result = board[x];
    int opponent = tenLog(result);
    int opponentPawn = -1;
    for (int i = 0; i < 4; i++) {
      if (positionPawns[4 * opponent + i] == x) {
        goToField(opponent, result, i);
        break;
      }
    }
    kills.value += 1;
  }

  Future<void> endTurn() async {
    print('|endTurn|');
    if (score.value == 6) {
      if (!everyoneInBaseOrFinish()) {
        setWaitForMoveValue(false);
        return await doBotTurn();
      }
    } else if (kills.value > 0) {
      kills.value -= 1;
      setWaitForMoveValue(false);
      return await doBotTurn();
    } else if (finished.value > 0) {
      finished.value -= 1;
      setWaitForMoveValue(false);
      return await doBotTurn();
    }
    await Future.delayed(const Duration(seconds: 2), getNextPlayer);
  }

  int tenPow(int exponent) {
    final List<int> results = [1, 10, 100, 1000];
    if (exponent < 0 || exponent > 3) {
      return 0;
    }
    return results[exponent];
  }

  int tenLog(int n) {
    return n.toString().length - 1;
  }

  void getNextPlayer() {
    int currentIndex = nextPlayer.value;
    int nextIndex = (currentIndex + 1) % colors.length;
    currentPlayer.value = nextPlayer.value;
    nextPlayer.value = nextIndex;
    scores.value = '';
    score.value = 0;
    setWaitForMoveValue(false);
    if (everyoneInFinish(player: nextPlayer.value)) {
      nextIndex = (nextIndex + 1) % colors.length;
      nextPlayer.value = nextIndex;
    }
    if (bots[currentPlayer.value]) {
      doBotTurn();
    }
  }

  void showBoard() {
    print(board);
    print(positionPawns);
  }

  Future<void> doBotTurn() async {
    int cpv = currentPlayer.value;
    if (!bots[cpv]) {
      return;
    }
    print('|doBotTurn| scores: $scores, waitForMove: $waitForMove');
    await Future.delayed(const Duration(seconds: 1));
    if (waitForMove.value) {
      print('|doBotTurn| CZEKAMY');
      setWaitForMoveValue(false);
      await Future.delayed(const Duration(seconds: 15));
      print('|doBotTurn| POCZEKANE');
    }
    await rollDice(player: cpv);
    await Future.delayed(const Duration(seconds: 1));
    print('|doBotTurn| AFTER: score: $score, scores: $scores');
    int dice = score.value;
    int pow = tenPow(cpv);
    if (waitForMove.value) {
      List<int> possMoves = List.filled(4, -1);
      for (int i = 0; i < 4; i++) {
        possMoves[i] = whereToGo(positionPawns[4 * cpv + i], dice, cpv);
      }
      print('|doBotTurn| $possMoves');
      if (possMoves[0] == possMoves[1] &&
          possMoves[1] == possMoves[2] &&
          possMoves[2] == possMoves[3]) {
        int r = Random().nextInt(4);
        print('|doBotTurn| [IF] r: $r');
        try {
          await movePawn(pawnNumber: r);
        } catch (e) {
          print('426: $e');
          return await endTurn();
        }
      } else if (dice == 6) {
        /// Wyjdź z bazy
        int r = Random().nextInt(4);
        print('|doBotTurn| [ELSE] r: $r');
        if (((board[cpv] + board[6 * cpv + 61]) ~/ pow) > r) {
          List<int> values = [0, 1, 2, 3];
          values.shuffle(Random());
          for (int value in values) {
            if (possMoves[value] == 13 * cpv + 4) {
              await movePawn(pawnNumber: value);
              break;
            }
          }
        } else {
          /// TODO
          List<int> values = [0, 1, 2, 3];
          values.shuffle(Random());
          for (int value in values) {
            if (possMoves[value] != 13 * cpv + 4) {
              try {
                await movePawn(pawnNumber: value);
                break;
              } catch (e) {
                print(e);
              }
            }
          }
        }
      } else {
        List<int> values = [0, 1, 2, 3];
        values.shuffle(Random());

        /// BICIA
        for (int value in values) {
          print(
              '|BOT| BICIA - canCapture(possMoves[$value], $pow): ${canCapture(possMoves[value], pow)}');
          if (canCapture(possMoves[value], pow)) {
            await movePawn(pawnNumber: value);
            return;
          }
        }

        /// KOŃCOWE POLE
        for (int value in values) {
          print(
              '|BOT| KOŃCOWE - possMoves[$value] > 55 : ${possMoves[value] > 55}');
          if (possMoves[value] > 55 && positionPawns[4 * cpv + value] < 56) {
            try {
              await movePawn(pawnNumber: value);
              print('return');
              return;
            } on ArgumentError catch (e) {
              print('Przechwycono błąd: ${e.message}');
            }
          }
        }

        /// KOŃCOWE POLE
        for (int value in values) {
          List<int> endFields = [61, 67, 73, 79];
          if (endFields.contains(possMoves[value])) {
            try {
              await movePawn(pawnNumber: value);
              print('return');
              return;
            } on ArgumentError catch (e) {
              print('Przechwycono błąd: ${e.message}');
            }
          }
        }

        /// BEZPIECZNE POLE
        List<int> safeFields = [4, 12, 17, 25, 30, 38, 43, 51];
        for (int value in values) {
          if (safeFields.contains(possMoves[value])) {
            await movePawn(pawnNumber: value);
            return;
          }
        }

        /// TODO
        for (int value in values) {
          print('|BOT| - $value');
          try {
            await movePawn(pawnNumber: value);
            print('return');
            return;
          } on ArgumentError catch (e) {
            print('Przechwycono błąd: ${e.message}');
          }
        }
      }
    }
  }
}
