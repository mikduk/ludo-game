import 'package:get/get.dart';
import 'dart:math';

class GamePageController extends GetxController {
  final List<String> colors = ['Blue', 'Red', 'Green', 'Yellow'];

  var score = 0.obs;
  var scores = ''.obs;
  var currentPlayer = 'Blue'.obs;
  var nextPlayer = 'Red'.obs;
  var waitForMove = false.obs;
  var board = List.filled(80, 0).obs;
  var kills = 0.obs;
  bool showSnackbar = false;
  var positionPawns = List.filled(16, 0).obs;

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
    currentPlayer.value = 'Blue';
    nextPlayer.value = 'Red';
    waitForMove = false.obs;
    score = 0.obs;
    scores = ''.obs;

    board[0] = 4;
    board[1] = 40;
    board[2] = 400;
    board[3] = 4000;

    for (int i=0; i<16; i++) {
      positionPawns[i] = i ~/ 4;
    }
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

  Future<void> rollDice({String player = '', int possibilities = 6}) async {
    print('|rollDice| waitForMove: $waitForMove');
    if (waitForMove.value) {
      if (showSnackbar) {
        Get.snackbar('Uwaga', 'Wykonaj ruch pionka!',
            snackPosition: SnackPosition.BOTTOM);
      }
      return;
    }

    if (player == currentPlayer.value) {
      score.value = Random().nextInt(possibilities) + (6 - possibilities) + 1;
      scores.value += score.value.toString();

      await automaticallyMovePawn();
    }
  }

  Future<void> automaticallyMovePawn() async {
    if (everyoneInBase() && score.value != 6) {
      await Future.delayed(const Duration(seconds: 1), getNextPlayer);
    } else if (scores.value.contains('666')) {
      await Future.delayed(const Duration(seconds: 2), getNextPlayer);
    } else {
      waitForMove.value = true;
    }
  }

  bool everyoneInBase() {
    int currentIndex = colors.indexOf(currentPlayer.value);
    int pow = tenPow(currentIndex);
    return (board[currentIndex] == 4 * pow);
  }

  Future<void> moveFirstPawn() async => await movePawn(pawnNumber: 0);
  Future<void> moveSecondPawn() async => await movePawn(pawnNumber: 1);
  Future<void> moveThirdPawn() async => await movePawn(pawnNumber: 2);
  Future<void> moveFourthPawn() async => await movePawn(pawnNumber: 3);

  Future<void> movePawn({int? pawnNumber}) async {
    print('|movePawn| waitForMove: $waitForMove');
    if (waitForMove.value) {
      try {
        await movePlayerPawn(pawnNumber);
        if (showSnackbar) {
          Get.snackbar('Tytuł', 'Ruch pionka wykonany!',
              snackPosition: SnackPosition.BOTTOM);
        }
        waitForMove.value = false;
      } catch (e) {
        print('|movePawn| $e');
        if (showSnackbar) {
          Get.snackbar('Tytuł', 'Ruch tego pionka zabroniony!',
              snackPosition: SnackPosition.BOTTOM);
        }
      }
    } else {
      if (showSnackbar) {
        Get.snackbar('Tytuł', 'Nie teraz byczku ;)',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  Future<void> movePlayerPawn(int? pawnNumber) async {
    int currentIndex = colors.indexOf(currentPlayer.value);
    int pow = tenPow(currentIndex);

    print('|movePlayerPawn| currentIndex: $currentIndex, pow: $pow');

    // Pierwszy ruch
    if (score.value == 6 && positionPawns[4 * currentIndex + (pawnNumber ?? 0)] == currentIndex) {
      board[currentIndex] -= pow;
      int x = currentIndex * 13 + 4;
      await goToField(x, pow, pawnNumber ?? 0);
    } else if (positionPawns[4 * currentIndex + (pawnNumber ?? 0)] != currentIndex) {
      int i = positionPawns[4 * currentIndex + (pawnNumber ?? 0)];
      board[i] -= pow;
      int x = whereToGo(i, score.value, currentIndex);
      await goToField(x, pow, pawnNumber ?? 0);
    } else {
      throw ArgumentError('Pionek $pawnNumber. $currentPlayer nie może się ruszyć.');
    }
    print('|movePlayerPawn| END');
  }

  int whereToGo(int i, int n, int colorIndex) {
    print('|whereToGo| i: $i, n: $n, colorIndex: $colorIndex');
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
    await endTurn();
    print('|goToField| END');
  }

  Future<void> goToFieldAnimate(int from, int to, int pow, {Duration delayTime=const Duration(milliseconds: 180)}) async {
    int originalPosition = from;
    while (from != to) {
      if (3 < from && to < 56) {
        from++;
        if (from > 55) {
          from = 4;
        }
        board[from] += pow;
      } else {
        return;
      }
      await Future.delayed(delayTime);
      board[from] -= pow;
    }
  }

  bool canCapture(int x, int pow, {bool teamMode=false}) {
    List<int> saveFields = [4, 12, 17, 25, 30, 38, 43, 51];
    List<int> attackMoves = [1, 10, 100, 1000];
    int result = board[x];

    if (x < 4 || x > 55 || saveFields.contains(x)) {
      return false;
    } else if (attackMoves.contains(result) && pow != result) { // TODO
      return true;
    }
    return false;
  }

  Future<void> capture(int x, int pow) async {
    print('|capture| x: $x, pow: $pow');
    int result = board[x];
    int opponent = tenLog(result);
    print('|capture| result: $result, opponent: $opponent');
    board[opponent] += result;
    for (int i=0; i<4; i++) {
      if (positionPawns[4 * opponent + i] == x) {
        positionPawns[4 * opponent + i] = opponent;
      }
    }
    kills.value += 1;
  }

  Future<void> endTurn() async {
    print('|endTurn|');
    if (score.value == 6) {
      return;
    } else if (kills.value > 0) {
      kills.value -= 1;
      waitForMove.value = true;
      return;
    } else {
      await Future.delayed(const Duration(seconds: 2), getNextPlayer);
    }
    // TODO: EXTRA CASE WHEN END
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
    int currentIndex = colors.indexOf(nextPlayer.value);
    int nextIndex = (currentIndex + 1) % colors.length;
    String tmp = colors[nextIndex];
    currentPlayer.value = nextPlayer.value;
    nextPlayer.value = tmp;
    scores.value = '';
    score.value = 0;
  }

  void showBoard() {
    print(board);
    print(positionPawns);
  }
}
