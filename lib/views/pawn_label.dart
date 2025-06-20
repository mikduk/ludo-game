// pawn_label.dart – ikona szachowego pionka z prawidłowym mapowaniem kolorów
// i poprawnym wyróżnieniem aktywnego gracza.
// ───────────────────────────────────────────────────────────────────────────────
// • Kolejność cyfr w wartościach pól (po uzupełnieniu do 4 znaków):
//     [0] Y (Yellow)  [1] G (Green)  [2] R (Red)  [3] B (Blue)
// • Indeksy gracza (currentPlayer):
//     0 → Blue, 1 → Red, 2 → Green, 3 → Yellow
//   ⇒ Piony aktywnego gracza znajdują się w cyfrze o indeksie (3 - currentPlayer).
//     Przykład: currentPlayer=0 (Blue) ⇒ aktywne piony w indeksie 3 (B).
//
//   110 → "0110"  ⇒ 1×G, 1×R – żadnego dla Blue (akt. glow się NIE pokaże).

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/screen_controller.dart';

class PawnLabel extends StatelessWidget {
  final int fieldValue;            // Wartość z planszy
  final int currentPlayer;         // 0-Blue, 1-Red, 2-Green, 3-Yellow
  final VoidCallback? regenerate;  // Ewentualne odświeżenie przy błędzie
  final bool waitForMove;

  const PawnLabel({
    super.key,
    required this.fieldValue,
    required this.currentPlayer,
    this.regenerate,
    this.waitForMove = false
  });

  /* ───────────────────── kolory dla cyfr ───────────────────── */
  static const _digitColors = [
    Color(0xFFFBC02D), // Y – Yellow 700
    Color(0xFF388E3C), // G – Green 700
    Color(0xFFD32F2F), // R – Red 700
    Color(0xFF1976D2), // B – Blue 700
  ];

  @override
  Widget build(BuildContext context) {
    final counts = _extractCounts(fieldValue);      // [Y,G,R,B]
    final double iconSize = _iconSize(context);     // adaptacyjny rozmiar

    // Dzielimy na „zwykłe” i aktywne, aby glow był na wierzchu
    final List<Widget> normal = [];
    final List<Widget> active = [];

    for (int digit = 0; digit < 4; digit++) {
      final isActive = digit == (3 - currentPlayer) && waitForMove;
      final listTarget = isActive ? active : normal;
      listTarget.addAll(
        List.generate(
          counts[digit],
              (_) => _PawnIcon(
            color: _digitColors[digit],
            size: iconSize,
            isActive: isActive,
          ),
        ),
      );
    }

    final pawns = [...normal, ...active];
    if (pawns.isEmpty) return const SizedBox.shrink();

    return pawns.length == 1
        ? pawns.first
        : Wrap(
      alignment: WrapAlignment.center,
      spacing: 2,
      runSpacing: 2,
      children: pawns,
    );
  }

  /* ───────────────────── helpers ───────────────────── */

  List<int> _extractCounts(int field) {
    final str = field.toString().padLeft(4, '0'); // np. 110 => "0110"
    return List<int>.generate(4, (i) => int.parse(str[i]));
  }

  double _iconSize(BuildContext context) {
    final screen = Get.find<ScreenController>();
    return 14 * (screen.getFieldSize() / 29);
  }
}

/* ──────────────────── pojedynczy pionek ──────────────────── */

class _PawnIcon extends StatelessWidget {
  final Color color;
  final double size;
  final bool isActive;

  const _PawnIcon({
    required this.color,
    required this.size,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final icon = FaIcon(FontAwesomeIcons.chessPawn, color: color, size: size);
    if (!isActive) return icon;

    // Glow – bez deprecated withOpacity
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(230),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: icon,
    );
  }
}