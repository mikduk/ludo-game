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
  final bool lastField;

  const PawnLabel({
    super.key,
    required this.fieldValue,
    required this.currentPlayer,
    this.regenerate,
    this.waitForMove = false,
    this.lastField = false,
  });

  /* ───────────────────── kolory dla cyfr ───────────────────── */
  static const _digitColors = [
    Color(0xFFFBC02D), // Y – Yellow 700
    Color(0xFF388E3C), // G – Green 700
    Color(0xFFD32F2F), // R – Red 700
    Color(0xFF1976D2), // B – Blue 700
  ];

  static const _backgroundColors = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    final counts = _extractCounts(fieldValue);      // [Y,G,R,B]
    final int totalPawns = counts.reduce((a, b) => a + b);
    final double iconSize = _iconSize(context);     // adaptacyjny rozmiar

    // Dzielimy na „zwykłe” i aktywne, aby glow był na wierzchu
    final List<Widget> normal = [];
    final List<Widget> active = [];

    for (int digit = 0; digit < 4; digit++) {
      final isActive = digit == (3 - currentPlayer) && waitForMove;
      final listTarget = isActive ? active : normal;
      if (totalPawns > 5) {
        listTarget.add(
          PawnCountBadge(
            count: counts[digit],
            color: _digitColors[digit],
            size: iconSize,
            isActive: isActive,
          ),
        );
      } else {
        listTarget.addAll(
          List.generate(
            counts[digit],
                (_) => PawnIcon(
              color: _digitColors[digit],
              size: (lastField ? 0.8 : 1) * iconSize ,
              isActive: isActive,
            ),
          ),
        );
      }
    }

    final pawns = [...normal, ...active];
    if (pawns.isEmpty) {
      return const SizedBox.shrink();
    }

    // dostosowanie odstępów i rozmiarów
    final isCrowded = pawns.length >= 3;
    final spacing = isCrowded ? 0.05 : 2.0;
    final pawnScale = isCrowded ? 0.72 : 1.0;

      return pawns.length == 1
          ? pawns.first
          :
      (totalPawns > 5
      ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [pawns[2], pawns[1]]),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [pawns[3], pawns[0]]),
        ],
      )
      : (
          lastField
          ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 3, child: Container()),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Expanded(flex: 3, child: Container()), pawns.length >= 3 ? pawns[2] : emptyPawn(iconSize), Expanded(flex: 2, child: Container()), pawns.length >= 2 ? pawns[1] : emptyPawn(iconSize), Expanded(flex: 3, child: Container())]),
              Expanded(flex: 2, child: Container()),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Expanded(flex: 3, child: Container()), pawns.length >= 4 ? pawns[3] : emptyPawn(iconSize), Expanded(flex: 2, child: Container()), pawns.isNotEmpty ? pawns[0] : emptyPawn(iconSize), Expanded(flex: 3, child: Container())]),
              Expanded(flex: 2, child: Container()),
            ],
          )
          : Wrap(
        alignment: WrapAlignment.center,
        spacing: spacing,
        runSpacing: spacing,
        children: pawns.map((p) => Transform.scale(scale: pawnScale, child: p)).toList(),
      ))
      );

  }

  PawnIcon emptyPawn(double iconSize) {
    return PawnIcon(
  color: Colors.transparent,
  size: 0.8 * iconSize ,
  isActive: false,
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

class PawnIcon extends StatelessWidget {
  final Color color;
  final double size;
  final bool isActive;

  const PawnIcon({super.key,
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

class PawnCountBadge extends StatelessWidget {
  final int count;
  final Color color;
  final double size;
  final bool isActive;

  const PawnCountBadge({
    super.key,
    required this.count,
    required this.color,
    required this.size,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    // zwiększamy badge bardziej widocznie
    final badgeSize = size * 0.9;

    return Container(
      width: badgeSize,
      height: badgeSize,
      margin: const EdgeInsets.all(0.4), // odstęp między badge’ami
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 0.8),
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: color.withAlpha(220),
              blurRadius: 10,
              spreadRadius: 2,
            )
          else
            const BoxShadow(
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(0, 1),
            )
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: badgeSize * 0.55,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          shadows: const [
            Shadow(
              blurRadius: 1,
              color: Colors.black38,
              offset: Offset(0.5, 0.5),
            )
          ],
        ),
      ),
    );
  }
}
