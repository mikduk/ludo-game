import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';

import '../models/fields.dart';
import '../models/game_modes.dart';
import '../models/keys/game_page_controller_keys.dart';
import '../models/players.dart';
import '../views/statistics_dialog.dart';
import 'auto_moves_controller.dart';
import 'sound_controller.dart';
import 'stats_controller.dart';
import 'package:get/get.dart';
import 'dart:math';

class GamePageController extends GetxController {
  final List<String> namesOfPlayers;
  final List<bool> valuesOfBots;
  final GameModes gameMode;
  final bool clearOnLoad;
  final bool useGetStorage;
  final bool testMode;
  final GetStorage _storage = GetStorage();

  GamePageController({
    this.namesOfPlayers = const ['Blue', 'Red', 'Green', 'Yellow'],
    this.valuesOfBots = const [true, false, true, true],
    this.gameMode = GameModes.classic,
    this.clearOnLoad = true,
    this.useGetStorage = true,
    this.testMode = false,
  }) : assert(
          namesOfPlayers.length == valuesOfBots.length,
          'The number of player names must match the number of bot flags.',
        );

  final botWaitForRollDuration = const Duration(milliseconds: 620);
  final shorterDuration = const Duration(milliseconds: 1200);
  final normalDuration = const Duration(milliseconds: 1600);
  final longerDuration = const Duration(milliseconds: 2800);
  final movementDuration = const Duration(milliseconds: 180);
  final nextBotDuration = const Duration(milliseconds: 300);

  var score = 0.obs;
  var scores = ''.obs;
  var currentPlayer = Player.blue.index.obs;
  var nextPlayer = Player.red.index.obs;
  var waitForMove = false.obs;
  var board = List.filled(80, 0).obs;
  var kills = 0.obs;
  var finished = 0.obs;
  RxBool processedCapture = false.obs;
  var positionPawns = List.filled(16, 0).obs;

  late final List<String> colors;
  var bots = List.filled(4, false).obs;
  RxBool teamWork = true.obs;

  var autoMoves = List.filled(4, false).obs;

  RxBool stopGame = false.obs;

  bool rollDicePlayerFlag = false;
  RxBool fieldActionFlag = false.obs;

  List<String> logs = [];

  final SoundController soundController = Get.put(SoundController());
  final StatsController statsController = Get.put(StatsController());

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    if (useGetStorage && clearOnLoad) {
      clearStorage();
    }
    initializePlayers();
    initializeBoard();
    statsController.reset();
    if (useGetStorage && !clearOnLoad) {
      _loadFromStorage();
    }
    regenerateBoard();
    if (useGetStorage) {
      ever(statsController.turnsCounter, (_) => _saveToStorage());
    }
    executePeriodicallyBots();
  }

  Future<void> executePeriodicallyBots() async {
    await Future.delayed(const Duration(seconds: 3));
    while (!gameOver()) {
      if (!stopGame.value) {
        await doBotTurn(inputPlayer: currentPlayer.value);
      }
      await Future.delayed(nextBotDuration);
    }
    print('KONIEC GRY');
    soundController.playEndSound();
    showStatisticsDialog();
  }

  bool gameOver() {
    if (teamWork.value) {
      return ((everyoneInFinish(player: 0) && everyoneInFinish(player: 2)) ||
          (everyoneInFinish(player: 1) && everyoneInFinish(player: 3)));
    } else {
      return (board[79] ~/ 4000 +
              board[73] ~/ 400 +
              board[67] ~/ 40 +
              board[61] ~/ 4 >=
          3);
    }
  }

  void initializePlayers() {
    colors = namesOfPlayers;
    bots = valuesOfBots.obs;
    teamWork = (gameMode == GameModes.cooperation).obs;
  }

  void initializeBoard() {
    rollDicePlayerFlag = false;
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

    if (testMode) {
      positionPawns[4] = 13;
      positionPawns[5] = 11;
      positionPawns[6] = 8;
      positionPawns[7] = 10;
      positionPawns[15] = 79;
      positionPawns[14] = 79;
      positionPawns[13] = 79;
      positionPawns[12] = 79;
    }

  }

  void regenerateBoard() {
    board.value = List.filled(80, 0);
    for (int i = 0; i < 16; i++) {
      int pow = tenPow(i ~/ 4);
      board[positionPawns[i]] += pow;
    }
  }

  int getCurrentPlayer() {
    if (everyoneInFinish() &&
        teamWork.value &&
        !everyoneInBaseOrFinishOrCannotGo(player: getPlayerFriend())) {
      return getPlayerFriend();
    }
    return currentPlayer.value;
  }

  Future<void> rollDicePlayer(
      {int player = -1, int possibilities = 6, int? result}) async {
    if (rollDicePlayerFlag) {
      return;
    }
    if (autoMoves[player]) {
      printForLogs('|rollDicePlayer| autoMoves[player: $player]');
      return;
    }
    rollDicePlayerFlag = true;
    await rollDice(
        player: player, possibilities: possibilities, result: result);
    rollDicePlayerFlag = false;
  }

  Future<void> rollDice(
      {int player = -1, int possibilities = 6, int? result}) async {
    if (waitForMove.value) {
      return;
    }
    if (player == currentPlayer.value) {
      result = getRandomValue(possibilities, result);
      processedCapture.value = false;
      score.value = result;
      scores.value += result.toString();
      bool rollForFriend = everyoneInFinish(player: player) && teamWork.value;
      statsController.recordRoll(player, result, rollForFriend);

      printForLogs(
          '|rollDice| ($player, $possibilities, $result) | Wyrzucono: $score => $scores');

      await automaticallyMovePawn(player: player);
    }
  }

  void setFieldActionFlag({bool? value}) {
    value ??= !fieldActionFlag.value;
    fieldActionFlag.value = value;
  }

  static int getRandomValue(int possibilities, int? result) {
    List<int> diceResults = [6, 1, 5, 2, 4, 3];
    int value = Random().nextInt(possibilities);
    result ??= diceResults[value];
    return result;
  }

  void autoMovesSwitch(int player, {int? inputPlayer}) {
    printForLogs(
        '|autoMovesSwitch| player: $player, inputPlayer: $inputPlayer, zmiana: ${autoMoves[player]} => ${!autoMoves[player]}');
    autoMoves[player] = !autoMoves[player];
  }

  void startStopGame() {
    stopGame.value = !stopGame.value;
    if (stopGame.value) {
      showLogsDialog();
    }
  }

  void showLogsDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('logs'.tr),
        content: SizedBox(
          width: double.maxFinite, // żeby lista mogła się rozszerzyć
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: logs.length,
            itemBuilder: (_, i) => Text(logs[logs.length - i - 1],
                style: TextStyle(
                    fontSize: 8,
                    color:
                        (logs[logs.length - i - 1].contains('[${colors[1]}]\n')
                            ? Colors.red[800]
                            : Colors.black87),
                    fontWeight:
                        (logs[logs.length - i - 1].contains('[${colors[3]}]\n')
                            ? FontWeight.bold
                            : FontWeight.normal))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String lastSixty = '_${'logs'.tr}:_\n\n';
              for (int i = 0; i < min(60, logs.length); i++) {
                String tmpLog = logs[logs.length - i - 1];
                if (tmpLog.contains('[${colors[3]}]\n')) {
                  tmpLog = tmpLog.replaceFirst('\n', '\n*');
                  tmpLog = tmpLog.replaceAll('\n', '*\n');
                  tmpLog = '*$tmpLog';
                }
                lastSixty += '$tmpLog\n';
              }
              SharePlus.instance.share(ShareParams(text: lastSixty));
            },
            child: Text('share'.tr),
          ),
          TextButton(
            onPressed: () => Get.back(), // zamknij okno
            child: Text('close'.tr),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  void soundSwitch() => soundController.soundSwitch();

  void changeBotFlag(int player) {
    bots[player] = !bots[player];
  }

  void changeMode() {
    teamWork.value = !teamWork.value;
  }

  void printForLogs(String x) {
    if (currentPlayer.value >= 0) {
      String timestamp = DateTime.now().toIso8601String();
      print(
          '[printForLogs] [${statsController.turnsCounter.value}][${colors[currentPlayer.value]}][$timestamp] $x');
      logs.add(
          '[${statsController.turnsCounter.value}][${colors[currentPlayer.value]}]\n$x\n');
    }
  }

  Future<void> automaticallyMovePawn({int player = -1}) async {
    print('[AMP] $currentPlayer | $scores | $score');
    if (player != currentPlayer.value) {
      print('[AMP] player vs. currentPlayer: $player != $currentPlayer');
      return;
    }
    bool rollForFriend = everyoneInFinish(player: player) && teamWork.value;
    if (scores.value.contains('666')) {
      statsController.recordTripleSix(player, rollForFriend);
      soundController.playFalseSuccessFailSound();
      printForLogs('|AMP| 666 (trzecia szóstka) gracz: $player');
      await Future.delayed(longerDuration, getNextPlayer);
    } else if (everyoneInFinish()) {
      printForLogs('|AMP| (everyoneInFinish)');
      if (rollForFriend &&
          !everyoneInBaseOrFinishOrCannotGo(player: getPlayerFriend())) {
        statsController.resetTurnsWithoutMove(getPlayerFriend());
        setWaitForMoveValue(true);
      } else {
        printForLogs('|AMP| else (everyoneInFinish)');
        statsController.recordSkip(player, score.value, rollForFriend);
        soundController.playFailRollSound();
        await Future.delayed(normalDuration, getNextPlayer);
      }
    } else if (everyoneInBaseOrFinish()) {
      if (score.value != 6) {
        if (onlyYouInBaseOrFinish()) {
          soundController.playRandomlyLaugh();
        }
        printForLogs('|AMP| n != 6 (everyoneInBaseOrFinish)');
        statsController.recordSkip(player, score.value, rollForFriend);
        statsController.increaseTurnsWithoutMove(player);
        await Future.delayed(normalDuration, getNextPlayer);
      } else {
        statsController.resetTurnsWithoutMove(player);
        soundController.playRandomlyCongrats();
        printForLogs('|AMP| n == 6 (everyoneInBaseOrFinish)');
        setWaitForMoveValue(true);
      }
    } else if (everyoneInBaseOrFinishOrCannotGo()) {
      printForLogs('|AMP| (everyoneInBaseOrFinishOrCannotGo)');
      statsController.increaseTurnsWithoutMove(player);
      statsController.recordSkip(player, score.value, false);
      soundController.playFailRollSound();
      await Future.delayed(normalDuration, getNextPlayer);
    } else {
      printForLogs('|AMP| ELSE - będzie normalny ruch (result: $score)');
      statsController.resetTurnsWithoutMove(player);
      setWaitForMoveValue(true);
    }
  }

  int getPlayerFriend({int? player}) {
    player ??= currentPlayer.value;
    if (teamWork.value) {
      switch (player) {
        case 0:
          return 2;
        case 1:
          return 3;
        case 2:
          return 0;
        case 3:
          return 1;
      }
    }
    return player;
  }

  bool everyoneInFinish({int? player}) {
    player ??= currentPlayer.value;
    int pow = tenPow(player);
    return (board[Field.blueFinish.index + player * 6] == 4 * pow);
  }

  bool everyoneInBaseOrFinish({int? player}) {
    player ??= currentPlayer.value;
    int pow = tenPow(player);
    return (board[player] + board[Field.blueFinish.index + player * 6] == 4 * pow);
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

  bool everyoneInBaseOrFinishOrCannotGo({int? player}) {
    bool result = true;
    player ??= currentPlayer.value;

    for (int i = 0; i < 4; i++) {
      int pawnField = positionPawns[4 * player + i];
      if (pawnField != player &&
          (pawnField + score.value) <= (Field.blueFinish.index + player * 6)) {
        return false;
      } else if (score.value == 6 && pawnField == player) {
        return false;
      }
    }
    return result;
  }

  Future<void> movePawn({int? pawnNumber}) async {
    if (waitForMove.value) {
      try {
        await movePlayerPawn(pawnNumber);
      } catch (e) {
        print('|movePawn| $e');
        rethrow;
      }
    }
  }

  void setWaitForMoveValue(bool value) {
    print('|setWaitForMoveValue| value: $value');
    if (value) {
      printForLogs('|setWaitForMoveValue| (true) - czekamy NA RUCH');
    } else {
      printForLogs('|setWaitForMoveValue| (false) - czekamy na RZUT');
    }
    waitForMove.value = value;
  }

  Future<void> movePlayerPawn(int? pawnNumber) async {
    int currentIndex = getCurrentPlayer();
    int pow = tenPow(currentIndex);
    bool forFriend = (currentPlayer.value != currentIndex);

    printForLogs(
        '|movePlayerPawn| (pawnNumber: $pawnNumber) currentIndex: $currentIndex, pow: $pow');
    print('|movePlayerPawn| currentIndex: $currentIndex, pow: $pow');

    // Pierwszy ruch
    if (score.value == 6 &&
        positionPawns[4 * currentIndex + (pawnNumber ?? 0)] == currentIndex) {
      board[currentIndex] -= pow;
      int x = currentIndex * 13 + 4;
      printForLogs('|movePlayerPawn| WYJŚCIE Z BAZY');
      await goToField(x, pow, pawnNumber ?? 0);
      statsController.recordMove(currentIndex, score.value);
      if (forFriend) {
        statsController.recordMoveFriend(currentPlayer.value, score.value);
      }
      await endTurn();
    } else if (positionPawns[4 * currentIndex + (pawnNumber ?? 0)] !=
        currentIndex) {
      int i = positionPawns[4 * currentIndex + (pawnNumber ?? 0)];
      board[i] -= pow;
      int x = whereToGo(i, score.value, currentIndex);
      if (x == i) {
        board[i] += pow;
        printForLogs(
            '${'pawn'.tr.capitalizeFirst} $pawnNumber. ${colors[currentPlayer.value]} nie może się ruszyć.');
        return;
      }
      printForLogs('|movePlayerPawn| PÓJŚĆCIE NA POLE $x, x: $x =?= i: $i');
      statsController.recordMove(currentIndex, score.value);
      if (forFriend) {
        statsController.recordMoveFriend(currentPlayer.value, score.value);
      }
      await goToField(x, pow, pawnNumber ?? 0);
      await endTurn();
    } else {
      printForLogs('${'pawn'.tr.capitalizeFirst} $pawnNumber. $currentPlayer nie może się ruszyć.');
      throw ArgumentError(
          '${'pawn'.tr.capitalizeFirst} $pawnNumber. $currentPlayer nie może się ruszyć.');
    }
  }

  int whereToGo(int i, int n, int colorIndex) {
    int inputI = i;

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
      if (translatedI >= 56 && translatedI <= 61) {
        if (translatedI + n <= 61) {
          translatedI += n;
        }
      } else if (translatedI == 55) {
        printForLogs('ERROR - tu nie powinno być pionka: $i');
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
    return i;
  }

  Future<void> goToField(int x, int pow, int pawnNumber) async {
    await goToFieldAnimate(positionPawns[4 * tenLog(pow) + pawnNumber], x, pow,
        delayTime: movementDuration);
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
      soundController.playCompleteSound();
    }
    // await endTurn();
  }

  Future<void> goToFieldAnimate(int from, int to, int pow,
      {Duration delayTime = const Duration(milliseconds: 180)}) async {
    int originalPosition = to;
    Field originalTo = Field.values[to];
    Field originalFrom = Field.values[from];
    if (Field.baseIndexes.contains(to)) {
      Field toField = Field.values[to];
      switch (toField) {
        case Field.blueBase:
          to = Field.blueStart.index;
          break;
        case Field.redBase:
          to = Field.redStart.index;
          break;
        case Field.greenBase:
          to = Field.greenStart.index;
          break;
        case Field.yellowBase:
          to = Field.yellowStart.index;
          break;
        default:
          printForLogs('|goToFieldAnimate| [if] SYNTAX ERROR (from: ${originalFrom.name}, to: ${originalTo.name}, pow: $pow)');
          break;
      }
    } else if (Field.baseIndexes.contains(from)) {
      soundController.playGoOutSound();
    }
    while (from != to) {
      if ((3 < from && to < Field.blueCorridor1.index && to == originalPosition) ||
          (from >= 56 && to >= Field.blueCorridor1.index)) {
        from++;
        if (from > 55 && to < Field.blueCorridor1.index) {
          from = 4;
        }
        board[from] += pow;
      } else if (to >= Field.blueCorridor1.index) {
        from++;
        Field fromField = Field.values[from];
        switch (fromField) {
          case Field.blue12:
            from = Field.redCorridor1.index;
            break;
          case Field.red12:
            from = Field.greenCorridor1.index;
            break;
          case Field.green12:
            from = Field.yellowCorridor1.index;
            break;
          case Field.yellow12:
            from = Field.blueCorridor1.index;
            break;
          default:
            printForLogs('|goToFieldAnimate| [while] SYNTAX ERROR (fromField: ${fromField.name})');
            break;
        }
        board[from] += pow;
      } else if (Field.baseIndexes.contains(originalPosition)) {
        from--;
        if (from < Field.yellowBase.index) {
          from = Field.yellow12.index;
        }
        board[from] += pow;
      } else {
        return;
      }
      await Future.delayed(delayTime);
      board[from] -= pow;
    }
  }

  bool canCapture(int x, int pow) {
    List<int> safeFields = [
      Field.blueStart.index, Field.blue8Safe.index,
      Field.redStart.index, Field.red8Safe.index,
      Field.greenStart.index, Field.green8Safe.index,
      Field.yellowStart.index, Field.yellow8Safe.index
    ];
    List<int> attackMoves = [1, 10, 100, 1000];
    List<int> attackMovesA = [
      10,
      11,
      12,
      13,
      14,
      110,
      111,
      112,
      113,
      114,
      210,
      211,
      212,
      213,
      214,
      310,
      311,
      312,
      313,
      314,
      410,
      411,
      412,
      413,
      1000,
      1001,
      1002,
      1003,
      1004,
      1100,
      1101,
      1102,
      1103,
      1104,
      1200,
      1201,
      1202,
      1203,
      1204,
      1300,
      1301,
      1302,
      1303,
      1304,
      1400,
      1401,
      1402,
      1403
    ];
    List<int> attackMovesB = [
      1,
      11,
      21,
      31,
      41,
      100,
      110,
      120,
      130,
      140,
      1001,
      1011,
      1021,
      1031,
      1041,
      1100,
      1110,
      1120,
      1130,
      1140,
      2001,
      2011,
      2021,
      2031,
      2041,
      2100,
      2110,
      2120,
      2130,
      2140,
      3001,
      3011,
      3021,
      3031,
      3041,
      3100,
      3110,
      3120,
      3130,
      3140,
      4001,
      4011,
      4021,
      4031,
      4031,
      4100,
      4110,
      4120,
      4130
    ];
    int result = board[x];
    bool teamMode = teamWork.value;

    if (x < 4 || x > 55 || safeFields.contains(x) || pow == result) {
      printForLogs(
          '|canCapture| (pole: $x, $pow) BRAK BICIA (baza, meta, bezpieczne pole lub swój ${'pawn'.tr})');
      return false;
    } else if (teamMode &&
        (pow == 1 || pow == 100) &&
        attackMovesA.contains(result)) {
      return true;
    } else if (teamMode &&
        (pow == 10 || pow == 1000) &&
        attackMovesB.contains(result)) {
      printForLogs(
          '|canCapture| (pole: $x, $pow) BICIE (tryb współpracy, dokładnie jeden niebieski albo zielony ${'pawn'.tr})');
      return true;
    } else if (!teamMode && attackMoves.contains(result)) {
      return true;
    } else if (!teamMode) {
      switch (pow) {
        case 1:
          if ([11, 12, 13, 101, 102, 103, 1001, 1002, 1003].contains(result)) {
            return true;
          }
          break;
        case 10:
          if ([11, 21, 31, 110, 120, 130, 1010, 1020, 1030].contains(result)) {
            return true;
          }
          break;
        case 100:
          if ([101, 201, 301, 110, 210, 310, 1100, 1200, 1300]
              .contains(result)) {
            return true;
          }
          break;
        case 1000:
          if ([1001, 1002, 1003, 1010, 1020, 1030, 1100, 1200, 1300]
              .contains(result)) {
            printForLogs(
                '|canCapture| (pole: $x, $pow) BICIE (tryb solo, dokładnie jeden nieżółty ${'pawn'.tr})');
            return true;
          }
          break;
      }
    }
    printForLogs(
        '|canCapture| (pole: $x, $pow) BRAK BICIA (nie wpadło w żaden case)');
    return false;
  }

  Future<void> capture(int x, int pow) async {
    if (soundController.soundOn.isTrue) {
      soundController.playCaptureSound();
      soundController.playRandomlyLaugh();
    }
    print('|capture| x: $x, pow: $pow');
    int result = board[x];
    board[x] = result + pow - getOpponentPow(pow, result);
    int opponent = tenLog(result);

    printForLogs('|capture| x: $x, pow: $pow, opponent: $opponent');

    for (int i = 0; i < 4; i++) {
      if (positionPawns[4 * opponent + i] == x) {
        statsController.recordKill(tenLog(pow),
            victim: opponent, forFriend: tenLog(pow) != currentPlayer.value);
        await goToField(opponent, result, i);
        break;
      }
    }
    print('|capture| kills++');
    kills.value += 1;
  }

  int getOpponentPow(int attackerPow, int result) {
    List<int> digits = result
        .toString()
        .padLeft(4, '0')
        .split('')
        .map(int.parse)
        .toList()
        .reversed
        .toList();
    List<int> possibleOpponentIndexes = [0, 1, 2, 3];
    possibleOpponentIndexes.remove(tenLog(attackerPow));
    if (teamWork.isTrue) {
      possibleOpponentIndexes.remove((tenLog(attackerPow) + 2) % 4);
    }
    int sum = 0;
    for (int i in possibleOpponentIndexes) {
      sum += digits[i];
    }
    if (sum == 1) {
      for (int i in possibleOpponentIndexes) {
        if (digits[i] == 1) {
          return tenPow(i);
        }
      }
    }
    return 0;
  }

  Future<void> endTurn() async {
    print(
        '|endTurn| currentPlayer: $currentPlayer, scores: $scores, kills: $kills, finished: $finished');
    printForLogs(
        '|endTurn| currentPlayer: $currentPlayer, scores: $scores, kills: $kills, finished: $finished');

    if (score.value == 6) {
      printForLogs('[END TURN] SCORE: 6 (następny ruch?)');
      if (!everyoneInBaseOrFinish(player: getCurrentPlayer())) {
        printForLogs('[END TURN] !everyoneInBaseOrFinish (dalej!)');
        setWaitForMoveValue(false);
        return;
      }
    } else if (kills.value > 0) {
      printForLogs('[END TURN] KILLS: 1+ (następny ruch)');
      kills.value -= 1;
      processedCapture.value = true;
      setWaitForMoveValue(false);
      return;
    } else if (finished.value > 0) {
      printForLogs('[END TURN] FINISHED: 1+ (następny ruch?)');
      finished.value -= 1;
      setWaitForMoveValue(false);

      print(
          '|endTurn| ${everyoneInFinish()} | ${everyoneInFinish(player: getCurrentPlayer())} KONIEC?');
      printForLogs(
          '|END TURN| everyoneInFinish($currentPlayer): ${everyoneInFinish()} | everyoneInFinish(player: ${getCurrentPlayer()}): ${everyoneInFinish(player: getCurrentPlayer())} (KONIEC?)');

      if (everyoneInFinish() && !teamWork.value) {
        printForLogs('|END TURN| Wszyscy na mecie (tryb solo)');
        soundController.playBravoSound();
      } else {
        statsController.setFinished(currentPlayer.value);
        return;
      }
    }
    printForLogs('[END TURN] KONIEC TEJ FUNKCJI');
    setWaitForMoveValue(false);
    await Future.delayed(shorterDuration, getNextPlayer);
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
    int preIndex = (currentIndex - 1) % colors.length;

    printForLogs(
        '[getNextPlayer] (PRZED) STARY GRACZ: ${colors[currentPlayer.value]} -> nowy gracz: ${colors[nextPlayer.value]}');

    currentPlayer.value = nextPlayer.value;
    nextPlayer.value = nextIndex;
    scores.value = '';
    score.value = 0;
    kills.value = 0;
    finished.value = 0;

    if (preIndex > currentIndex) {
      statsController.nextTurn();
    }

    printForLogs(
        '[getNextPlayer] (PO) stary gracz: ${colors[preIndex]} -> NOWY GRACZ: ${colors[currentIndex]}');

    setWaitForMoveValue(false);

    if (!teamWork.value) {
      if (everyoneInFinish(player: nextPlayer.value)) {
        nextIndex = (nextIndex + 1) % colors.length;
        nextPlayer.value = nextIndex;
      }
      if (everyoneInFinish(player: nextPlayer.value)) {
        nextIndex = (nextIndex + 1) % colors.length;
        nextPlayer.value = nextIndex;
      }
    }
  }

  void showStatistics() {
    print('\n\nSTATYSTYKI:\n');
    for (int i = 0; i < 4; i++) {
      print('=================');
      print('Kolor ${colors[i]}');
      print('');
      print('Zbił: ${statsController.kills[i]} (${statsController.kills[i]})');
      print('Został zbity: ${statsController.deaths[i]}');
      print('');
      print(
          'Potrójna szóstka: ${statsController.tripleSix[i]} (${statsController.tripleSixFriend[i]})');
      for (int j = 0; j < 6; j++) {
        print(
            '[${j + 1}] wyrzucono: ${statsController.rolls[6 * i + j]} (${statsController.rollsFriend[6 * i + j]}), ruch: ${statsController.moves[6 * i + j]} (${statsController.movesFriend[6 * i + j]}), skip: ${statsController.skips[6 * i + j]} (${statsController.skipsFriend[6 * i + j]})');
      }
      print('\n');
    }
  }

  void showStatisticsDialog() {
    Get.dialog(
      StatisticsDialog(statsController: statsController),
      barrierDismissible: false,
    );
  }

  void showBoard() {
    print(board);
    print(positionPawns);
  }

  Future<void> doBotTurn({int? inputPlayer}) async {
    if (!bots[currentPlayer.value] && !autoMoves[currentPlayer.value]) {
      return;
    }
    int hash = Random().nextInt(40321);
    int cpv = getCurrentPlayer();
    printForLogs(
        '|doBotTurn|[$hash] (player: $inputPlayer) cpv: $cpv, scores: $scores, waitForMove: $waitForMove');
    // print('|doBotTurn| scores: $scores, waitForMove: $waitForMove');
    await Future.delayed(botWaitForRollDuration);
    if (waitForMove.value) {
      return;
    }
    await rollDice(player: currentPlayer.value);
    await Future.delayed(shorterDuration);

    if (cpv != getCurrentPlayer()) {
      printForLogs(
          '|doBotTurn|[$hash] cpv: $cpv, getCurrentPlayer(): ${getCurrentPlayer()} | RUCH BOTA ${colors[cpv].toUpperCase()} POWINIEN SIĘ SKOŃCZYĆ');
      return;
    }

    printForLogs(
        '|doBotTurn|[$hash] AFTER ROLL: score: $score, scores: $scores');
    int dice = score.value;
    int pow = tenPow(cpv);
    printForLogs(
        '|doBotTurn|[$hash] if (${waitForMove.value}[waitForMove]): dice: $dice, pow: $pow');
    if (!waitForMove.value) {
      return;
    }

    List<int> possMoves = List.filled(4, -1);
    for (int i = 0; i < 4; i++) {
      possMoves[i] = whereToGo(positionPawns[4 * cpv + i], dice, cpv);
    }

    int? p = AutoMovesController.moveIfOnlyOnePossibility(this, cpv, dice);
    if (p != null) {
      await movePawn(pawnNumber: p);
      return;
    } else if (autoMoves[currentPlayer.value]) {
      autoMovesSwitch(cpv, inputPlayer: currentPlayer.value);
      return;
    }

    p = AutoMovesController.thinkAboutBestMove(this, cpv, dice);
    if (p != null) {
      await movePawn(pawnNumber: p);
      return;
    }

    await endTurn();
  }

  Future<void> clearStorage() async {
    if (useGetStorage) {
      await _storageClear();
      await statsController.storageClearAll();
    }
  }

  Future<void> _storageClear() async {
    await _storage.remove(GamePageControllerKeys.score);
    await _storage.remove(GamePageControllerKeys.scores);
    await _storage.remove(GamePageControllerKeys.currentPlayer);
    await _storage.remove(GamePageControllerKeys.nextPlayer);
    await _storage.remove(GamePageControllerKeys.waitForMove);
    await _storage.remove(GamePageControllerKeys.board);
    await _storage.remove(GamePageControllerKeys.kills);
    await _storage.remove(GamePageControllerKeys.finished);
    await _storage.remove(GamePageControllerKeys.processedCapture);
    await _storage.remove(GamePageControllerKeys.positionPawns);
    await _storage.remove(GamePageControllerKeys.bots);
    await _storage.remove(GamePageControllerKeys.autoMoves);
    await _storage.remove(GamePageControllerKeys.teamWork);
  }

  void _saveToStorage() {
    _saveStateToStorage();
    statsController.storageSaveAll();
  }

  void _saveStateToStorage() {
    try {
      _storage.write(GamePageControllerKeys.score,              score.value);
      _storage.write(GamePageControllerKeys.scores,             scores.value);
      _storage.write(GamePageControllerKeys.currentPlayer,      currentPlayer.value);
      _storage.write(GamePageControllerKeys.nextPlayer,         nextPlayer.value);
      _storage.write(GamePageControllerKeys.waitForMove,        waitForMove.value);

      _storage.write(GamePageControllerKeys.board,              board.toList());
      _storage.write(GamePageControllerKeys.kills,              kills.value);
      _storage.write(GamePageControllerKeys.finished,           finished.value);
      _storage.write(GamePageControllerKeys.processedCapture,   processedCapture.value);
      _storage.write(GamePageControllerKeys.positionPawns,      positionPawns.toList());

      _storage.write(GamePageControllerKeys.bots,               bots.toList());
      _storage.write(GamePageControllerKeys.autoMoves,          autoMoves.toList());
      _storage.write(GamePageControllerKeys.teamWork,           teamWork.value);

    } catch (e, st) {
      printForLogs('Error saving GamePageController state: $e\n$st');
    }
  }

  void _loadFromStorage() {
    _loadStateFromStorage();
    statsController.storageLoadAll();
  }

  void _loadStateFromStorage() {
    try {
      score.value            = _storage.read<int>(GamePageControllerKeys.score)              ?? score.value;
      scores.value           = _storage.read<String>(GamePageControllerKeys.scores)          ?? scores.value;
      currentPlayer.value    = _storage.read<int>(GamePageControllerKeys.currentPlayer)      ?? currentPlayer.value;
      nextPlayer.value       = _storage.read<int>(GamePageControllerKeys.nextPlayer)         ?? nextPlayer.value;
      waitForMove.value      = _storage.read<bool>(GamePageControllerKeys.waitForMove)       ?? waitForMove.value;

      final rawBoard = _storage.read<List<dynamic>>(GamePageControllerKeys.board);
      if (rawBoard != null && rawBoard.length == board.length) {
        board.value = rawBoard.cast<int>();
      }

      kills.value            = _storage.read<int>(GamePageControllerKeys.kills)             ?? kills.value;
      finished.value         = _storage.read(GamePageControllerKeys.finished)          ?? finished.value;
      processedCapture.value = _storage.read<bool>(GamePageControllerKeys.processedCapture) ?? processedCapture.value;
      teamWork.value = _storage.read<bool>(GamePageControllerKeys.teamWork) ?? teamWork.value;

      final rawPos = _storage.read<List<dynamic>>(GamePageControllerKeys.positionPawns);
      if (rawPos != null && rawPos.length == positionPawns.length) {
        positionPawns.value = rawPos.cast<int>();
      }

      final rawBots = _storage.read<List<dynamic>>(GamePageControllerKeys.bots);
      if (rawBots != null && rawBots.length == bots.length) {
        bots.value = rawBots.cast<bool>();
      }
      final rawAuto = _storage.read<List<dynamic>>(GamePageControllerKeys.autoMoves);
      if (rawAuto != null && rawAuto.length == autoMoves.length) {
        autoMoves.value = rawAuto.cast<bool>();
      }

    } catch (e, st) {
      printForLogs('Error loading GamePageController state: $e\n$st');
    }
  }
}
