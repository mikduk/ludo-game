import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/keys/stats_controller_keys.dart';

class StatsController extends GetxController {

  final _storage = GetStorage();

  final kills            = List<int>.filled(4, 0).obs;
  final killsFriend      = List<int>.filled(4, 0).obs;
  final deaths           = List<int>.filled(4, 0).obs;
  final tripleSix        = List<int>.filled(4, 0).obs;
  final tripleSixFriend  = List<int>.filled(4, 0).obs;
  final turnsWithoutMove = List<int>.filled(4, 0).obs;

  final rolls            = List<int>.filled(24, 0).obs;
  final moves            = List<int>.filled(24, 0).obs;
  final skips            = List<int>.filled(24, 0).obs;
  final rollsFriend      = List<int>.filled(24, 0).obs;
  final movesFriend      = List<int>.filled(24, 0).obs;
  final skipsFriend      = List<int>.filled(24, 0).obs;

  final finishedAndHelped = <int>[].obs;

  RxInt turnsCounter = 0.obs;

  int _idx(int player, int dice) => player * 6 + dice - 1;
  int _friend(int player) => (player + 2) % 4;

  void storageSaveAll() {
    _storage.write(StatsControllerKeys.keyKills, kills.toList());
    _storage.write(StatsControllerKeys.keyKillsFriend, killsFriend.toList());
    _storage.write(StatsControllerKeys.keyDeaths, deaths.toList());
    _storage.write(StatsControllerKeys.keyTripleSix, tripleSix.toList());
    _storage.write(StatsControllerKeys.keyTripleSixFriend, tripleSixFriend.toList());
    _storage.write(StatsControllerKeys.keyTurnsWithoutMove, turnsWithoutMove.toList());

    _storage.write(StatsControllerKeys.keyRolls, rolls.toList());
    _storage.write(StatsControllerKeys.keyMoves, moves.toList());
    _storage.write(StatsControllerKeys.keySkips, skips.toList());
    _storage.write(StatsControllerKeys.keyRollsFriend, rollsFriend.toList());
    _storage.write(StatsControllerKeys.keyMovesFriend, movesFriend.toList());
    _storage.write(StatsControllerKeys.keySkipsFriend, skipsFriend.toList());

    _storage.write(StatsControllerKeys.keyFinishedAndHelped, finishedAndHelped.toList());
    _storage.write(StatsControllerKeys.keyTurnsCounter, turnsCounter.value);
  }

  void storageLoadAll() {
    kills.value = _storage
        .read<List<dynamic>>(StatsControllerKeys.keyKills)
        ?.cast<int>()
        ?? List<int>.filled(4, 0);
    killsFriend.value = _storage
        .read<List<dynamic>>(StatsControllerKeys.keyKillsFriend)
        ?.cast<int>()
        ?? List<int>.filled(4, 0);
    deaths.value = _storage
        .read<List<dynamic>>(StatsControllerKeys.keyDeaths)
        ?.cast<int>()
        ?? List<int>.filled(4, 0);
    tripleSix.value = _storage
        .read<List<dynamic>>(StatsControllerKeys.keyTripleSix)
        ?.cast<int>()
        ?? List<int>.filled(4, 0);
    tripleSixFriend.value = _storage
        .read<List<dynamic>>(StatsControllerKeys.keyTripleSixFriend)
        ?.cast<int>()
        ?? List<int>.filled(4, 0);
    turnsWithoutMove.value = _storage
        .read<List<dynamic>>(StatsControllerKeys.keyTurnsWithoutMove)
        ?.cast<int>()
        ?? List<int>.filled(4, 0);

    rolls.value = _storage
        .read<List<dynamic>>(StatsControllerKeys.keyRolls)
        ?.cast<int>()
        ?? List<int>.filled(24, 0);
    moves.value = _storage
        .read<List<dynamic>>(StatsControllerKeys.keyMoves)
        ?.cast<int>()
        ?? List<int>.filled(24, 0);
    skips.value = _storage
        .read<List<dynamic>>(StatsControllerKeys.keySkips)
        ?.cast<int>()
        ?? List<int>.filled(24, 0);

    rollsFriend.value = _storage
        .read<List<dynamic>>(StatsControllerKeys.keyRollsFriend)
        ?.cast<int>()
        ?? List<int>.filled(24, 0);
    movesFriend.value = _storage
        .read<List<dynamic>>(StatsControllerKeys.keyMovesFriend)
        ?.cast<int>()
        ?? List<int>.filled(24, 0);
    skipsFriend.value = _storage
        .read<List<dynamic>>(StatsControllerKeys.keySkipsFriend)
        ?.cast<int>()
        ?? List<int>.filled(24, 0);

    finishedAndHelped.value = _storage
        .read<List<dynamic>>(StatsControllerKeys.keyFinishedAndHelped)
        ?.cast<int>()
        ?? <int>[];

    turnsCounter.value = _storage
        .read<int>(StatsControllerKeys.keyTurnsCounter)
        ?? 0;
  }

  Future<void> storageClearAll() async {
    await _storage.remove(StatsControllerKeys.keyKills);
    await _storage.remove(StatsControllerKeys.keyKillsFriend);
    await _storage.remove(StatsControllerKeys.keyDeaths);
    await _storage.remove(StatsControllerKeys.keyTripleSix);
    await _storage.remove(StatsControllerKeys.keyTripleSixFriend);
    await _storage.remove(StatsControllerKeys.keyTurnsWithoutMove);

    await _storage.remove(StatsControllerKeys.keyRolls);
    await _storage.remove(StatsControllerKeys.keyMoves);
    await _storage.remove(StatsControllerKeys.keySkips);
    await _storage.remove(StatsControllerKeys.keyRollsFriend);
    await _storage.remove(StatsControllerKeys.keyMovesFriend);
    await _storage.remove(StatsControllerKeys.keySkipsFriend);

    await _storage.remove(StatsControllerKeys.keyFinishedAndHelped);
    await _storage.remove(StatsControllerKeys.keyTurnsCounter);

    reset();
  }

  void reset() {
    for (var l in [kills, killsFriend, deaths, tripleSix, tripleSixFriend, turnsWithoutMove]) {
      l.fillRange(0, 4, 0);
    }
    for (var l in [rolls, moves, skips, rollsFriend, movesFriend, skipsFriend]) {
      l.fillRange(0, 24, 0);
    }
    finishedAndHelped.value = [];
    turnsCounter.value = 0;
  }

  /* ---------- PUBLIC API ---------- */

  void recordRoll(int player, int dice, bool forFriend) {
    _validatePlayerValue(player);
    rolls[_idx(player, dice)]++;
    if (forFriend) {
      rollsFriend[_idx(player, dice)]++;
      rollsFriend[_idx(_friend(player), dice)]++;
    }
  }

  void recordMove(int player, int dice) {
    _validatePlayerValue(player);
    moves[_idx(player, dice)]++;
  }

  void recordMoveFriend(int player, int dice) {
    _validatePlayerValue(player);
    movesFriend[_idx(player, dice)]++;
    movesFriend[_idx(_friend(player), dice)]++;
  }

  void recordSkip(int player, int dice, bool forFriend) {
    _validatePlayerValue(player);
    skips[_idx(player, dice)]++;
    if (forFriend) {
      skipsFriend[_idx(player, dice)]++;
      skipsFriend[_idx(_friend(player), dice)]++;
    }
  }

  void recordKill(int attacker, {required int victim, bool forFriend = false}) {
    int player = forFriend ? _friend(attacker) : attacker;
    kills[player]++;
    deaths[victim]++;
    if (forFriend) {
      killsFriend[player]++;
    }
  }

  void recordTripleSix(int player, bool forFriend) {
    _validatePlayerValue(player);
    tripleSix[player]++;
    if (forFriend) {
      tripleSixFriend[player]++;
      tripleSixFriend[_friend(player)]++;
    }
  }

  void nextTurn() => turnsCounter++;

  void setFinished(player) {
    _validatePlayerValue(player);
    if (!finishedAndHelped.contains(player)) {
      finishedAndHelped.add(player);
    }
  }

  void increaseTurnsWithoutMove(int player) {
    _validatePlayerValue(player);
    turnsWithoutMove[player]++;
  }

  void resetTurnsWithoutMove(int player) {
    _validatePlayerValue(player);
    if (turnsWithoutMove[player] > 0) {
     turnsWithoutMove[player] = 0;
    }
  }

  bool playerRolledForFriend(int player, {int minSum = 0}) {
    _validatePlayerValue(player);

    final start = player * 6;
    final total = rollsFriend
        .getRange(start, start + 6)
        .fold<int>(0, (sum, v) => sum + v);

    return total > minSum;
  }

  void _validatePlayerValue(int player) {
    assert(player >= 0 && player < 4, 'player index out of range (0-3)');
  }
}
