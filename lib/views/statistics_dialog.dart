import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../controllers/game_page_controller.dart';
import '../controllers/stats_controller.dart';
import 'start_page.dart';

class StatisticsDialog extends StatelessWidget {
  StatisticsDialog({super.key, required this.statsController});
  final StatsController statsController;
  final GamePageController gamePageController = Get.find<GamePageController>();


  @override
  Widget build(BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Container(
      width: Get.width * 0.8,
      height: Get.height * 0.7,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Statystyki',
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text('Liczba tur: ${statsController.turnsCounter}'),
          const SizedBox(height: 12),

          // ───── Gracze ─────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(4, _buildPlayerStatsCard),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ───── Nowa gra ─────
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: Text('new_game'.tr),
            onPressed: _clearCacheAndGoToStartPage,
          ),
        ],
      ),
    ),
  );

  void _clearCacheAndGoToStartPage() {
    gamePageController.clearStorage();
    Get.offAll(StartPage());
  }

  /// Buduje kartę z danymi jednego gracza.
  Widget _buildPlayerStatsCard(int playerIndex) {
    // Kolory i nazwy graczy.
    const colorNames = ['Blue', 'Red', 'Green', 'Yellow'];
    List<Color?> playerColors = [Colors.blue, Colors.red, Colors.green, Colors.yellow[600]];

    final name = colorNames[playerIndex];
    Color? color = playerColors[playerIndex];

    // Skróty do danych.
    final kills           = statsController.kills[playerIndex];
    final killsFriend     = statsController.killsFriend[playerIndex];
    final deaths          = statsController.deaths[playerIndex];
    final tripleSix       = statsController.tripleSix[playerIndex];
    final rolls           = statsController.rolls;
    final rollsFriend     = statsController.rollsFriend;
    final moves           = statsController.moves;
    final movesFriend     = statsController.movesFriend;
    final skips           = statsController.skips;
    final skipsFriend     = statsController.skipsFriend;
    final finishedAndHelped = statsController.finishedAndHelped;

    final bool friendMode = statsController.playerRolledForFriend(playerIndex);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───── Nagłówek ─────
            Text('Gracz: $name',
                style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),

            _rowIconText(Icons.check_circle_outline, Colors.green,
                'Zbił pionki: $kills${friendMode ? ' ($killsFriend)' : ''}'),
            _rowIconText(Icons.cancel_outlined, Colors.redAccent,
                'Został zbity: $deaths'),
            _rowIconText(Icons.star_rate_rounded, Colors.orange,
                'Potrójna szóstka: $tripleSix${friendMode ? ' ($tripleSix)' : ''}'),
            const SizedBox(height: 8),

            // ───── Rzuty i ruchy ─────
            Text('Rzuty, ruchy, skipy:',
                style: Get.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),

            Column(
              children: List.generate(6, (dice) => DiceStatRow(
                player: playerIndex,
                finishedAndHelped: finishedAndHelped,
                dice: dice,
                rolls: rolls,
                moves: moves,
                skips: skips,
                rollsFriend: friendMode ? rollsFriend : null,
                movesFriend: friendMode ? movesFriend : null,
                skipsFriend: friendMode ? skipsFriend : null,
              )),
            ),
          ],
        ),
      ),
    );
  }

  /// Mała pomoc do wiersza ikona + tekst.
  Widget _rowIconText(IconData icon, Color c, String txt) => Row(
    children: [
      Icon(icon, color: c),
      const SizedBox(width: 4),
      Expanded(child: Text(txt)),
    ],
  );
}

class DiceStatRow extends StatelessWidget {
  const DiceStatRow({
    super.key,
    required this.player,
    required this.finishedAndHelped,
    required this.dice,          // 0‑based (0‒5)
    required this.rolls,
    required this.moves,
    required this.skips,
    this.rollsFriend,
    this.movesFriend,
    this.skipsFriend,
  });

  final int player;
  final List<int> finishedAndHelped;
  final int dice;
  final List<int> rolls, moves, skips;
  final List<int>? rollsFriend, movesFriend, skipsFriend;

  @override
  Widget build(BuildContext context) {
    // indeks liczony raz, używany wielokrotnie
    int idx(int p, int d) => p * 6 + d;
    final List<Color?> colorsList = [Colors.blue, Colors.red, Colors.green, Colors.yellow[600]];
    List<Color?> colors = [colorsList[player], colorsList[(player + 2) % 4]];
    final bool ended = finishedAndHelped.contains(player);
    final bool hadSupport = finishedAndHelped.contains((player + 2) % 4);
    final r  = rolls[idx(player, dice)];
    final m  = moves[idx(player, dice)];
    final s  = skips[idx(player, dice)];
    final rf = rollsFriend? [idx(player, dice)];
    final mf = movesFriend? [idx(player, dice)];
    final sf = skipsFriend? [idx(player, dice)];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FaIcon(_diceIcon(dice), size: 20, color: Colors.blueGrey),
        const SizedBox(width: 8),

        // ×N (friend)
        _bold('×$r'),
        _friend(r, rf, ended, hadSupport, colors),
        const SizedBox(width: 12),

        // ruchy (🏃)
        const FaIcon(FontAwesomeIcons.personRunning, size: 14, color: Colors.green),
        const SizedBox(width: 4),
        _bold('$m'),
        _friend(m, mf, ended, hadSupport, colors),
        const SizedBox(width: 12),

        // skipy (✋)
        const FaIcon(FontAwesomeIcons.hand, size: 14, color: Colors.orange),
        const SizedBox(width: 4),
        _bold('$s'),
        _friend(s, sf, ended, hadSupport, colors),
      ],
    );
  }

  // ─────────── pomocnicze Span‑y ───────────
  Widget _bold(String txt) => Text(txt,
      style: const TextStyle(fontWeight: FontWeight.w600));

  Widget _friend(int v, int? v1, bool ended, bool hadS, colors) {
    if (v1 == null) return const SizedBox.shrink();
    int v2 = 0;
    if (ended) {
      v2 = v1;
      v1 = v - v2;
    } else if (hadS) {
      v2 = v1;
      v1 = v;
    }
    return Text.rich(
      TextSpan(children: [
        const TextSpan(text: ' ('),
        TextSpan(text: '$v1', style: TextStyle(color: colors[0])),
        if (v2 != null) ...[
          const TextSpan(text: ', '),
          TextSpan(text: '$v2', style: TextStyle(color: colors[1])),
        ],
        const TextSpan(text: ')'),
      ]),
    );
  }

  // ─────────── ikony kostek 1‑6 ───────────
  IconData _diceIcon(int idx) {
    switch (idx) {
      case 0:
        return FontAwesomeIcons.diceOne;
      case 1:
        return FontAwesomeIcons.diceTwo;
      case 2:
        return FontAwesomeIcons.diceThree;
      case 3:
        return FontAwesomeIcons.diceFour;
      case 4:
        return FontAwesomeIcons.diceFive;
      default:
        return FontAwesomeIcons.diceSix;
    }
  }
}
