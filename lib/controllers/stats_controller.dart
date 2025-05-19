import 'package:get/get.dart';

class StatsController extends GetxController {

  final kills           = List<int>.filled(4, 0).obs;
  final killsFriend     = List<int>.filled(4, 0).obs;
  final deaths          = List<int>.filled(4, 0).obs;
  final tripleSix       = List<int>.filled(4, 0).obs;
  final tripleSixFriend = List<int>.filled(4, 0).obs;

  final rolls           = List<int>.filled(24, 0).obs;
  final moves           = List<int>.filled(24, 0).obs;
  final skips           = List<int>.filled(24, 0).obs;
  final rollsFriend     = List<int>.filled(24, 0).obs;
  final movesFriend     = List<int>.filled(24, 0).obs;
  final skipsFriend     = List<int>.filled(24, 0).obs;

  final finishedAndHelped = List<int>.filled(0, 0).obs;

  RxInt turnsCounter = 0.obs;

  int _idx(int player, int dice) => player * 6 + dice - 1;
  int _friend(int player) => (player + 2) % 4;

  void reset() {
    kills.fillRange(0, 4, 0);
    killsFriend.fillRange(0, 4, 0);
    deaths.fillRange(0, 4, 0);
    tripleSix.fillRange(0, 4, 0);
    tripleSixFriend.fillRange(0, 4, 0);
    for (var l in [rolls, moves, skips, rollsFriend, movesFriend, skipsFriend]) {
      l.fillRange(0, 24, 0);
    }
    finishedAndHelped.value = [];
    turnsCounter.value = 0;
  }

  /* ---------- PUBLIC API ---------- */

  void recordRoll(int player, int dice, bool forFriend) {
    rolls[_idx(player, dice)]++;
    if (forFriend) {
      rollsFriend[_idx(player, dice)]++;
      rollsFriend[_idx(_friend(player), dice)]++;
    }
  }

  void recordMove(int player, int dice) =>
      moves[_idx(player, dice)]++;

  void recordMoveFriend(int player, int dice) { 
    movesFriend[_idx(player, dice)]++;
    movesFriend[_idx(_friend(player), dice)]++;
  }

  void recordSkip(int player, int dice, bool forFriend) {
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
    tripleSix[player]++;
    if (forFriend) {
      tripleSixFriend[player]++;
      tripleSixFriend[_friend(player)]++;
    }
  }

  void nextTurn() => turnsCounter++;

  void setFinished(player) {
    if (!finishedAndHelped.contains(player)) {
      finishedAndHelped.add(player);
    }
  }

  bool playerRolledForFriend(int player, {int minSum = 0}) {
    assert(player >= 0 && player < 4, 'player index out of range (0-3)');

    final start = player * 6;
    final total = rollsFriend
        .getRange(start, start + 6)
        .fold<int>(0, (sum, v) => sum + v);

    return total > minSum;
  }
}
