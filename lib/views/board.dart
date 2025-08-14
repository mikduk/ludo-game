import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/game_page_controller.dart';
import '../models/fields.dart';
import '../models/pawns.dart';
import 'squares/base_squared.dart';
import 'squares/board_squared.dart';
import 'squares/diagonal_squared.dart';
import 'squares/four_color_squared.dart';
import 'squares/finish_squared.dart';

class Board extends StatelessWidget {
  const Board(
      {super.key,
      required this.height,
      required this.width,
      required this.fieldSize});

  final double height;
  final double width;
  final double fieldSize;

  @override
  Widget build(BuildContext context) {
    double s = fieldSize;
    double t = s * 7;
    double l = (height > width) ? (width - fieldSize * 15) * 0.5 : 0;
    final GamePageController gameController = Get.find();

    return Padding(
        padding: EdgeInsets.only(
          top: (3 / 110) * height,
          bottom: (7 / 110) * height,
        ),
        child: Stack(
          children: <Widget>[
            dogPicture(t - s * 4.5, l + s * 2, 3 * s, 1, gameController),
            dogPicture(t - s * 7, l + s * 11.5, 3 * s, 2, gameController),
            dogPicture(t + s * 5, l + s * 0.75, 3 * s, 0, gameController),
            dogPicture(t + s * 2.5, l + s * 10.25, 3 * s, 3, gameController),
            Positioned(
              top: t - s * 1,
              left: l + s * 6,
              child: DiagonalSquare(
                size: s + 1,
                color1: Colors.green,
                color2: Colors.red,
                isTopLeftToBottomRight: false,
              ),
            ),
            Positioned(
              top: t + s * 1,
              left: l + s * 6,
              child: DiagonalSquare(
                size: s + 1,
                color1: Colors.red,
                color2: Colors.blue,
                isTopLeftToBottomRight: true,
              ),
            ),
            Positioned(
              top: t - s * 1,
              left: l + s * 8,
              child: DiagonalSquare(
                size: s + 1,
                color1: Colors.green,
                color2: Colors.yellow,
                isTopLeftToBottomRight: true,
              ),
            ),
            Positioned(
              top: t + s * 1,
              left: l + s * 8,
              child: DiagonalSquare(
                size: s + 1,
                color1: Colors.yellow,
                color2: Colors.blue,
                isTopLeftToBottomRight: false,
              ),
            ),
            Positioned(
              top: t + s * 0,
              left: l + s * 7,
              child: FourColorSquare(
                size: s + 1,
                topLeftColor: Colors.red,
                topRightColor: Colors.green,
                bottomLeftColor: Colors.blue,
                bottomRightColor: Colors.yellow,
                showBorder: true,
                borderColor: Colors.black,
                borderWidth: 0.0,
              ),
            ),
            Positioned(
                top: t,
                left: l,
                child: BoardSquare(
                    field: Field.blue11redEntrance, size: s + 1, color: Colors.red.shade50)),
            Positioned(
                top: t - s * 1,
                left: l,
                child: BoardSquare(field: Field.blue12, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 1,
                child: BoardSquare(
                    field: Field.redStart, size: s + 1, color: Colors.red.shade100)),
            Positioned(
                top: t - s * 1,
                left: l + s * 2,
                child: BoardSquare(field: Field.red1, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 3,
                child: BoardSquare(field: Field.red2, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 4,
                child: BoardSquare(field: Field.red3, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 5,
                child: BoardSquare(field: Field.red4, size: s + 1)),
            //
            Positioned(
                top: t - s * 2,
                left: l + s * 6,
                child: BoardSquare(field: Field.red5, size: s + 1)),
            Positioned(
                top: t - s * 3,
                left: l + s * 6,
                child: BoardSquare(field: Field.red6, size: s + 1)),
            Positioned(
                top: t - s * 4,
                left: l + s * 6,
                child: BoardSquare(field: Field.red7, size: s + 1)),
            Positioned(
                top: t - s * 5,
                left: l + s * 6,
                child: BoardSquare(
                    field: Field.red8Safe, size: s + 1, color: Colors.grey[400])),
            Positioned(
                top: t - s * 6,
                left: l + s * 6,
                child: BoardSquare(field: Field.red9, size: s + 1)),
            Positioned(
                top: t - s * 7,
                left: l + s * 6,
                child: BoardSquare(field: Field.red10, size: s + 1)),
            //
            Positioned(
                top: t - s * 7,
                left: l + s * 7,
                child: BoardSquare(
                    field: Field.red11greenEntrance, size: s + 1, color: Colors.green.shade50)),
            Positioned(
                top: t - s * 7,
                left: l + s * 8,
                child: BoardSquare(field: Field.red12, size: s + 1)),
            Positioned(
                top: t - s * 6,
                left: l + s * 8,
                child: BoardSquare(
                    field: Field.greenStart, size: s + 1, color: Colors.green.shade100)),
            Positioned(
                top: t - s * 5,
                left: l + s * 8,
                child: BoardSquare(field: Field.green1, size: s + 1)),
            Positioned(
                top: t - s * 4,
                left: l + s * 8,
                child: BoardSquare(field: Field.green2, size: s + 1)),
            Positioned(
                top: t - s * 3,
                left: l + s * 8,
                child: BoardSquare(field: Field.green3, size: s + 1)),
            Positioned(
                top: t - s * 2,
                left: l + s * 8,
                child: BoardSquare(field: Field.green4, size: s + 1)),
            //
            Positioned(
                top: t - s * 1,
                left: l + s * 9,
                child: BoardSquare(field: Field.green5, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 10,
                child: BoardSquare(field: Field.green6, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 11,
                child: BoardSquare(field: Field.green7, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 12,
                child: BoardSquare(
                    field: Field.green8Safe, size: s + 1, color: Colors.grey[400])),
            Positioned(
                top: t - s * 1,
                left: l + s * 13,
                child: BoardSquare(field: Field.green9, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 14,
                child: BoardSquare(field: Field.green10, size: s + 1)),
            Positioned(
                top: t - s * 0,
                left: l + s * 14,
                child: BoardSquare(
                    field: Field.green11yellowEntrance, size: s + 1, color: Colors.yellow.shade50)),
            //
            Positioned(
                top: t + s * 1,
                left: l + s * 14,
                child: BoardSquare(field: Field.green12, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 13,
                child: BoardSquare(
                    field: Field.yellowStart, size: s + 1, color: Colors.yellow.shade200)),
            Positioned(
                top: t + s * 1,
                left: l + s * 12,
                child: BoardSquare(field: Field.yellow1, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 11,
                child: BoardSquare(field: Field.yellow2, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 10,
                child: BoardSquare(field: Field.yellow3, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 9,
                child: BoardSquare(field: Field.yellow4, size: s + 1)),
            //
            Positioned(
                top: t + s * 2,
                left: l + s * 8,
                child: BoardSquare(field: Field.yellow5, size: s + 1)),
            Positioned(
                top: t + s * 3,
                left: l + s * 8,
                child: BoardSquare(field: Field.yellow6, size: s + 1)),
            Positioned(
                top: t + s * 4,
                left: l + s * 8,
                child: BoardSquare(field: Field.yellow7, size: s + 1)),
            Positioned(
                top: t + s * 5,
                left: l + s * 8,
                child: BoardSquare(
                    field: Field.yellow8Safe, size: s + 1, color: Colors.grey[400])),
            Positioned(
                top: t + s * 6,
                left: l + s * 8,
                child: BoardSquare(field: Field.yellow9, size: s + 1)),
            //
            Positioned(
                top: t + s * 7,
                left: l + s * 8,
                child: BoardSquare(field: Field.yellow10, size: s + 1)),
            Positioned(
                top: t + s * 7,
                left: l + s * 7,
                child: BoardSquare(
                    field: Field.yellow11blueEntrance, size: s + 1, color: Colors.blue.shade50)),
            Positioned(
                top: t + s * 7,
                left: l + s * 6,
                child: BoardSquare(field: Field.yellow12, size: s + 1)),
            //
            Positioned(
                top: t + s * 6,
                left: l + s * 6,
                child: BoardSquare(
                    field: Field.blueStart, size: s + 1, color: Colors.blue.shade100)),
            Positioned(
                top: t + s * 5,
                left: l + s * 6,
                child: BoardSquare(field: Field.blue1, size: s + 1)),
            Positioned(
                top: t + s * 4,
                left: l + s * 6,
                child: BoardSquare(field: Field.blue2, size: s + 1)),
            Positioned(
                top: t + s * 3,
                left: l + s * 6,
                child: BoardSquare(field: Field.blue3, size: s + 1)),
            Positioned(
                top: t + s * 2,
                left: l + s * 6,
                child: BoardSquare(field: Field.blue4, size: s + 1)),
            //
            Positioned(
                top: t + s * 1,
                left: l + s * 5,
                child: BoardSquare(field: Field.blue5, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 4,
                child: BoardSquare(field: Field.blue6, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 3,
                child: BoardSquare(field: Field.blue7, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 2,
                child: BoardSquare(
                    field: Field.blue8Safe, size: s + 1, color: Colors.grey[400])),
            Positioned(
                top: t + s * 1,
                left: l + s * 1,
                child: BoardSquare(field: Field.blue9, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 0,
                child: BoardSquare(field: Field.blue10, size: s + 1)),
            //
            Positioned(
                top: t + s * 6,
                left: l + s * 7,
                child: BoardSquare(
                    field: Field.blueCorridor1, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 5,
                left: l + s * 7,
                child: BoardSquare(
                    field: Field.blueCorridor2, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 4,
                left: l + s * 7,
                child: BoardSquare(
                    field: Field.blueCorridor3, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 3,
                left: l + s * 7,
                child: BoardSquare(
                    field: Field.blueCorridor4, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 1,
                left: l + s * 7,
                child: FinishSquare(
                    field: Field.blueFinish, size: s + 1, color: Colors.blue, border: false)),
            Positioned(
                top: t + s * 2,
                left: l + s * 7,
                child: BoardSquare(
                    field: Field.blueCorridor5, size: s + 1, color: Colors.blue.shade200)),
            //
            Positioned(
                top: t + s * 0,
                left: l + s * 1,
                child: BoardSquare(
                    field: Field.redCorridor1, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t + s * 0,
                left: l + s * 2,
                child: BoardSquare(
                    field: Field.redCorridor2, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t + s * 0,
                left: l + s * 3,
                child: BoardSquare(
                    field: Field.redCorridor3, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t + s * 0,
                left: l + s * 4,
                child: BoardSquare(
                    field: Field.redCorridor4, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t + s * 0,
                left: l + s * 6,
                child: FinishSquare(
                    field: Field.redFinish, size: s + 1, color: Colors.red, border: false)),
            Positioned(
                top: t + s * 0,
                left: l + s * 5,
                child: BoardSquare(
                    field: Field.redCorridor5, size: s + 1, color: Colors.red.shade200)),
            //
            Positioned(
                top: t - s * 6,
                left: l + s * 7,
                child: BoardSquare(
                    field: Field.greenCorridor1, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 5,
                left: l + s * 7,
                child: BoardSquare(
                    field: Field.greenCorridor2, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 4,
                left: l + s * 7,
                child: BoardSquare(
                    field: Field.greenCorridor3, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 3,
                left: l + s * 7,
                child: BoardSquare(
                    field: Field.greenCorridor4, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 1,
                left: l + s * 7,
                child: FinishSquare(
                    field: Field.greenFinish,
                    size: s + 1,
                    color: Colors.green,
                    border: false)),
            Positioned(
                top: t - s * 2,
                left: l + s * 7,
                child: BoardSquare(
                    field: Field.greenCorridor5, size: s + 1, color: Colors.green.shade200)),
            //
            Positioned(
                top: t + s * 0,
                left: l + s * 13,
                child: BoardSquare(
                    field: Field.yellowCorridor1, size: s + 1, color: Colors.yellow.shade300)),
            Positioned(
                top: t + s * 0,
                left: l + s * 12,
                child: BoardSquare(
                    field: Field.yellowCorridor2, size: s + 1, color: Colors.yellow.shade300)),
            Positioned(
                top: t + s * 0,
                left: l + s * 11,
                child: BoardSquare(
                    field: Field.yellowCorridor3, size: s + 1, color: Colors.yellow.shade300)),
            Positioned(
                top: t + s * 0,
                left: l + s * 10,
                child: BoardSquare(
                    field: Field.yellowCorridor4, size: s + 1, color: Colors.yellow.shade300)),
            Positioned(
                top: t + s * 0,
                left: l + s * 8,
                child: FinishSquare(
                    field: Field.yellowFinish,
                    size: s + 1,
                    color: Colors.yellow,
                    border: false)),
            Positioned(
                top: t + s * 0,
                left: l + s * 9,
                child: BoardSquare(
                    field: Field.yellowCorridor5, size: s + 1, color: Colors.yellow.shade300)),
            //
            Positioned(
                top: t + s * 5.5,
                left: l + s * 3,
                child: BaseSquare(
                    pawn: Pawn.blue1, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 5.5,
                left: l + s * 4,
                child: BaseSquare(
                    pawn: Pawn.blue2, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 6.5,
                left: l + s * 3,
                child: BaseSquare(
                    pawn: Pawn.blue3, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 6.5,
                left: l + s * 4,
                child: BaseSquare(
                    pawn: Pawn.blue4, size: s + 1, color: Colors.blue.shade200)),
            //
            Positioned(
                top: t - s * 4,
                left: l + s * 0.5,
                child: BaseSquare(
                    pawn: Pawn.red1, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t - s * 4,
                left: l + s * 1.5,
                child: BaseSquare(
                    pawn: Pawn.red2, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t - s * 3,
                left: l + s * 0.5,
                child: BaseSquare(
                    pawn: Pawn.red3, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t - s * 3,
                left: l + s * 1.5,
                child: BaseSquare(
                    pawn: Pawn.red4, size: s + 1, color: Colors.red.shade200)),
            //
            Positioned(
                top: t - s * 6.5,
                left: l + s * 10,
                child: BaseSquare(
                    pawn: Pawn.green1, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 6.5,
                left: l + s * 11,
                child: BaseSquare(
                    pawn: Pawn.green2, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 5.5,
                left: l + s * 10,
                child: BaseSquare(
                    pawn: Pawn.green3, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 5.5,
                left: l + s * 11,
                child: BaseSquare(
                    pawn: Pawn.green4, size: s + 1, color: Colors.green.shade200)),
            //
            Positioned(
                top: t + s * 3,
                left: l + s * 12.5,
                child: BaseSquare(
                    pawn: Pawn.yellow1, size: s + 1, color: Colors.yellow.shade300)),
            Positioned(
                top: t + s * 3,
                left: l + s * 13.5,
                child: BaseSquare(
                    pawn: Pawn.yellow2, size: s + 1, color: Colors.yellow.shade300)),
            Positioned(
                top: t + s * 4,
                left: l + s * 12.5,
                child: BaseSquare(
                    pawn: Pawn.yellow3, size: s + 1, color: Colors.yellow.shade300)),
            Positioned(
                top: t + s * 4,
                left: l + s * 13.5,
                child: BaseSquare(
                    pawn: Pawn.yellow4, size: s + 1, color: Colors.yellow.shade300)),
          ],
        ));
  }

  DogPicture dogPicture(double top, double left, double size, int player,
      GamePageController controller) {
    return DogPicture(
        top: top,
        left: left,
        size: size,
        player: player,
        controller: controller);
  }
}

class DogPicture extends StatelessWidget {
  final double top;
  final double left;
  final double size;
  final int player;
  final GamePageController controller;

  const DogPicture({
    super.key,
    required this.top,
    required this.left,
    required this.size,
    required this.player,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Center(
        child: Obx(() {
          final role = controller.bots[player] ? 'bot' : 'player';
          final path = 'assets/images/dogs/${player}_$role.png';
          final counter = controller.statsController.turnsWithoutMove[player];

          return Stack(
            alignment: (player == 0 || player == 3)
                ? AlignmentDirectional.topStart
                : AlignmentDirectional.topEnd,
            children: [
              Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    path,
                    width: size,
                    height: size,
                    fit: BoxFit.contain,
                  )),
              BlockedTurnsBadge(counter: counter),
            ],
          );
        }),
      ),
    );
  }
}

class BlockedTurnsBadge extends StatelessWidget {
  final int counter;

  const BlockedTurnsBadge({super.key, required this.counter});

  @override
  Widget build(BuildContext context) {
    if (counter <= 2) return const SizedBox.shrink();

    Color backgroundColor;
    Color textColor = Colors.white;
    double size = 24;

    if (counter <= 4) {
      backgroundColor = Colors.orange;
    } else if (counter <= 7) {
      backgroundColor = Colors.red;
      size = 27;
    } else {
      backgroundColor = Colors.red.shade900;
      size = 30 + counter * 1.0;
    }

    size = min(size, 46);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: OctagonPainter(
              color: backgroundColor,
              shadow: counter > 9
                  ? BoxShadow(
                color: Colors.redAccent.shade400,
                blurRadius: 6,
                spreadRadius: 2,
              )
                  : null,
            ),
          ),
          Text(
            '$counter',
            style: TextStyle(
              fontSize: 0.75 * (size - 12),
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: -4.0,
            ),
          ),
        ],
      ),
    );
  }
}

class OctagonPainter extends CustomPainter {
  final Color color;
  final BoxShadow? shadow;

  OctagonPainter({required this.color, this.shadow});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // cień
    if (shadow != null) {
      final shadowPaint = Paint()
        ..color = shadow!.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow!.blurRadius);
      _drawOctagon(canvas, center, size.width / 2 + shadow!.spreadRadius, shadowPaint);
    }

    // biały "ramka" – większy ośmiokąt
    final borderPaint = Paint()..color = Colors.white;
    const borderWidth = 2.0; // w pikselach
    _drawOctagon(canvas, center, size.width / 2, borderPaint);

    // kolorowe wypełnienie – mniejszy ośmiokąt
    final fillPaint = Paint()..color = color;
    _drawOctagon(canvas, center, size.width / 2 - borderWidth, fillPaint);
  }

  void _drawOctagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const int sides = 8;
    const angle = 2 * pi / sides;

    for (int i = 0; i < sides; i++) {
      final x = center.dx + radius * cos(angle * i - pi / 8);
      final y = center.dy + radius * sin(angle * i - pi / 8);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
