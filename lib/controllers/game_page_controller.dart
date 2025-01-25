import 'package:get/get.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

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
  RxBool processedCapture = false.obs;
  var positionPawns = List.filled(16, 0).obs;
  var bots = List.filled(4, false).obs;
  RxBool soundOn = true.obs;

  @override
  void onInit({bool test = false}) {
    super.onInit();
    if (test) {
      showSnackbar = true;
    }
    initializeBoard();
    executePeriodicallyBots();
  }

  Future<void> executePeriodicallyBots() async {
    await Future.delayed(const Duration(seconds: 3));
    while (board[79] ~/ 4000 + board[73] ~/ 400 + board[67] ~/ 40 + board[61] ~/ 4 < 3) {
      await doBotTurn();
      await Future.delayed(const Duration(milliseconds: 300));
    }
    print('KONIEC GRY');
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
  }

  @override
  void onReady() {
    super.onReady();
    print('Kontroler jest gotowy!');
  }

  @override
  void onClose() {
    print('Kontroler został zamknięty');
    super.onClose();
  }

  void regenerateBoard() {
    board.value = List.filled(80, 0);
    for (int i = 0; i < 16; i++) {
      int pow = tenPow(i ~/ 4);
      board[positionPawns[i]] += pow;
    }
  }

  Future<void> rollDice({int player = -1, int possibilities = 6, int? result}) async {
    print(
        '|rollDice| waitForMove: $waitForMove, currentPlayer: $currentPlayer, player: $player');
    if (waitForMove.value) {
      return;
    }
    if (player == currentPlayer.value) {
      List<int> diceResults = [6, 1, 5, 2, 4, 3];
      int value = Random().nextInt(possibilities);
      result ??= diceResults[value];
      processedCapture.value = false;
      score.value = result;
      scores.value += result.toString();
      print('|rollDice| value: $value, score: ${score.value}, scores: ${scores.value}');

      await automaticallyMovePawn();
    }
  }

  void soundSwitch() {
    soundOn.value = !soundOn.value;
  }

  void changeBotFlag(int player) {
    bots[player] = !bots[player];
  }

  Future<void> automaticallyMovePawn() async {
    if (everyoneInBaseOrFinish()) {
      if (score.value != 6) {
        if (onlyYouInBaseOrFinish()) {
          playRandomlyLaugh();
        }
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

  bool everyoneInBaseOrFinish({int? player}) {
    player ??= currentPlayer.value;
    int pow = tenPow(player);
    return (board[player] + board[61 + player * 6] ==
        4 * pow);
  }

  bool onlyYouInBaseOrFinish({int? player}) {
    player ??= currentPlayer.value;
    for (int i = 0; i < colors.length; i++) {
      if (player == i && !everyoneInBaseOrFinish(player: i)) {
        return false;
      } else if (player != i && everyoneInBaseOrFinish(player: i)) {
        return false;
      }
    }
    return true;
  }

  bool everyoneInBaseOrFinishOrCannotGo() {
    bool result = true;
    int cpv = currentPlayer.value;

    for (int i = 0; i < 4; i++) {
      int pawnField = positionPawns[4 * cpv + i];
      if (pawnField != cpv && (pawnField + score.value) <= (61 + cpv * 6)) {
        return false;
      } else if (score.value == 6 && pawnField == cpv) {
        return false;
      }
    }
    return result;
  }

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
      await endTurn();
    } else if (positionPawns[4 * currentIndex + (pawnNumber ?? 0)] !=
        currentIndex) {
      int i = positionPawns[4 * currentIndex + (pawnNumber ?? 0)];
      board[i] -= pow;
      int x = whereToGo(i, score.value, currentIndex);
      await goToField(x, pow, pawnNumber ?? 0);
      await endTurn();
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
    print('after await goToFieldAnimated');
    if (board[x] == 0) {
      board[x] = pow;
    } else if (canCapture(x, pow)) {
      // TODO
      await capture(x, pow);
      board[x] = pow;
    } else {
      board[x] += pow;
    }
    positionPawns[4 * tenLog(pow) + pawnNumber] = x;
    if ([61, 67, 73, 79].contains(x)) {
      finished.value += 1;
    }
    // await endTurn();
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
    } else if ([0, 1, 2, 3].contains(from)) {
      playClickSound(sound: 'sounds/goOut.mp3');
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
    print('GO TO FIELD - END');
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
    playClickSound();
    playRandomlyLaugh();
    print('|capture| x: $x, pow: $pow');
    int result = board[x];
    board[x] = pow; // TODO
    int opponent = tenLog(result);
    for (int i = 0; i < 4; i++) {
      if (positionPawns[4 * opponent + i] == x) {
        await goToField(opponent, result, i);
        break;
      }
    }
    print('|capture| kills++');
    kills.value += 1;
  }

  void playRandomSound() async {
    List<String> sounds = ['capture', 'goOut', 'bravo', 'laugh1', 'laugh2'];
    int i = Random().nextInt(sounds.length);
    playClickSound(sound: 'sounds/${sounds[i]}.mp3');
  }

  void playRandomlyLaugh() async {
    List<String> sounds = ['laugh1', 'laugh2'];
    int i = Random().nextInt(sounds.length);
    if (Random().nextInt(10) >= 9) {
      playClickSound(sound: 'sounds/${sounds[i]}.mp3');
    }
  }

  void playClickSound({String sound = 'sounds/capture.mp3'}) async {
    final player = AudioPlayer();
    await player.setSource(AssetSource(sound));
    await player.resume();
  }

  Future<void> endTurn() async {
    print('|endTurn| currentPlayer: $currentPlayer, scores: $scores, kills: $kills, finished: $finished');
    if (score.value == 6) {
      if (!everyoneInBaseOrFinish()) {
        setWaitForMoveValue(false);
        return;
      }
    } else if (kills.value > 0) {
      kills.value -= 1;
      processedCapture.value = true;
      setWaitForMoveValue(false);
      return;
    } else if (finished.value > 0) {
      finished.value -= 1;
      setWaitForMoveValue(false);
      if (everyoneInFinish()) {
        playClickSound(sound: 'sounds/bravo.mp3');
      } else {
        return;
      }
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
    print('|getNextPlayer| currentPlayer: $currentPlayer');
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
    if (everyoneInFinish(player: nextPlayer.value)) {
      nextIndex = (nextIndex + 1) % colors.length;
      nextPlayer.value = nextIndex;
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
      await Future.delayed(const Duration(seconds: 3));
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
      if (positionPawns[4 * cpv + 0] == positionPawns[4 * cpv + 1] &&
          positionPawns[4 * cpv + 1] == positionPawns[4 * cpv + 2] &&
          positionPawns[4 * cpv + 2] == positionPawns[4 * cpv + 3]) {
        int r = Random().nextInt(4);
        print('|doBotTurn| [IF] r: $r');
        try {
          await movePawn(pawnNumber: r);
        } catch (e) {
          print('426: $e');
          return await endTurn();
        }
      } else {
        if (dice == 6) {

          /// test
          for (int p = 0; p < 4; p++) {
            print('${positionPawns[4 * cpv + p]} --> ${possMoves[p]}');
          }

          int r = Random().nextInt(4);
          print('|doBotTurn| ((${board[cpv]} + ${board[6 * cpv + 61]}) ~/ $pow) > $r | ((board[cpv] + board[6 * cpv + 61]) ~/ pow) > r');
          if (((board[cpv] + board[6 * cpv + 61]) ~/ pow) > r) {
            List<int> valuesSix = [0, 1, 2, 3];
            valuesSix.shuffle(Random());
            for (int value in valuesSix) {
              if (possMoves[value] == 13 * cpv + 4) {
                await movePawn(pawnNumber: value);
                break;
              }
            }
          }
        }

        List<int> values = [];
        for (int value = 0; value < 4; value++) {
          if (possMoves[value] != positionPawns[4 * cpv + value]) {
            values.add(value);
          }
        }
        values.shuffle(Random());
        print(values);

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

        /// Zostań na bezpiecznym polu
        for (int value in values) {
          if (!safeFields.contains(positionPawns[4 * cpv + value])) {
            try {
              await movePawn(pawnNumber: value);
              return;
            } on ArgumentError catch (e) {
              print('Przechwycono błąd: ${e.message}');
            }
          }
        }

        /// TODO
        for (int value in values) {
          if (possMoves[value] != positionPawns[4 * cpv + value]) {
            try {
              await movePawn(pawnNumber: value);
              return;
            } on ArgumentError catch (e) {
              print('Przechwycono błąd: ${e.message}');
            }
          }
        }
        await endTurn();
      }
    }
  }
}
