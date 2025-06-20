import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/game_page_controller.dart';
import 'squares/base_squared.dart';
import 'squares/board_squared.dart';
import 'squares/diagonal_squared.dart';
import 'squares/four_color_squared.dart';

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
                    index: 15, size: s + 1, color: Colors.red.shade50)),
            Positioned(
                top: t - s * 1,
                left: l,
                child: BoardSquare(index: 16, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 1,
                child: BoardSquare(
                    index: 17, size: s + 1, color: Colors.red.shade100)),
            Positioned(
                top: t - s * 1,
                left: l + s * 2,
                child: BoardSquare(index: 18, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 3,
                child: BoardSquare(index: 19, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 4,
                child: BoardSquare(index: 20, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 5,
                child: BoardSquare(index: 21, size: s + 1)),
            //
            Positioned(
                top: t - s * 2,
                left: l + s * 6,
                child: BoardSquare(index: 22, size: s + 1)),
            Positioned(
                top: t - s * 3,
                left: l + s * 6,
                child: BoardSquare(index: 23, size: s + 1)),
            Positioned(
                top: t - s * 4,
                left: l + s * 6,
                child: BoardSquare(index: 24, size: s + 1)),
            Positioned(
                top: t - s * 5,
                left: l + s * 6,
                child: BoardSquare(
                    index: 25, size: s + 1, color: Colors.grey[400])),
            Positioned(
                top: t - s * 6,
                left: l + s * 6,
                child: BoardSquare(index: 26, size: s + 1)),
            Positioned(
                top: t - s * 7,
                left: l + s * 6,
                child: BoardSquare(index: 27, size: s + 1)),
            //
            Positioned(
                top: t - s * 7,
                left: l + s * 7,
                child: BoardSquare(
                    index: 28, size: s + 1, color: Colors.green.shade50)),
            Positioned(
                top: t - s * 7,
                left: l + s * 8,
                child: BoardSquare(index: 29, size: s + 1)),
            Positioned(
                top: t - s * 6,
                left: l + s * 8,
                child: BoardSquare(
                    index: 30, size: s + 1, color: Colors.green.shade100)),
            Positioned(
                top: t - s * 5,
                left: l + s * 8,
                child: BoardSquare(index: 31, size: s + 1)),
            Positioned(
                top: t - s * 4,
                left: l + s * 8,
                child: BoardSquare(index: 32, size: s + 1)),
            Positioned(
                top: t - s * 3,
                left: l + s * 8,
                child: BoardSquare(index: 33, size: s + 1)),
            Positioned(
                top: t - s * 2,
                left: l + s * 8,
                child: BoardSquare(index: 34, size: s + 1)),
            //
            Positioned(
                top: t - s * 1,
                left: l + s * 9,
                child: BoardSquare(index: 35, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 10,
                child: BoardSquare(index: 36, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 11,
                child: BoardSquare(index: 37, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 12,
                child: BoardSquare(
                    index: 38, size: s + 1, color: Colors.grey[400])),
            Positioned(
                top: t - s * 1,
                left: l + s * 13,
                child: BoardSquare(index: 39, size: s + 1)),
            Positioned(
                top: t - s * 1,
                left: l + s * 14,
                child: BoardSquare(index: 40, size: s + 1)),
            Positioned(
                top: t - s * 0,
                left: l + s * 14,
                child: BoardSquare(
                    index: 41, size: s + 1, color: Colors.yellow.shade50)),
            //
            Positioned(
                top: t + s * 1,
                left: l + s * 14,
                child: BoardSquare(index: 42, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 13,
                child: BoardSquare(
                    index: 43, size: s + 1, color: Colors.yellow.shade200)),
            Positioned(
                top: t + s * 1,
                left: l + s * 12,
                child: BoardSquare(index: 44, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 11,
                child: BoardSquare(index: 45, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 10,
                child: BoardSquare(index: 46, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 9,
                child: BoardSquare(index: 47, size: s + 1)),
            //
            Positioned(
                top: t + s * 2,
                left: l + s * 8,
                child: BoardSquare(index: 48, size: s + 1)),
            Positioned(
                top: t + s * 3,
                left: l + s * 8,
                child: BoardSquare(index: 49, size: s + 1)),
            Positioned(
                top: t + s * 4,
                left: l + s * 8,
                child: BoardSquare(index: 50, size: s + 1)),
            Positioned(
                top: t + s * 5,
                left: l + s * 8,
                child: BoardSquare(
                    index: 51, size: s + 1, color: Colors.grey[400])),
            Positioned(
                top: t + s * 6,
                left: l + s * 8,
                child: BoardSquare(index: 52, size: s + 1)),
            //
            Positioned(
                top: t + s * 7,
                left: l + s * 8,
                child: BoardSquare(index: 53, size: s + 1)),
            Positioned(
                top: t + s * 7,
                left: l + s * 7,
                child: BoardSquare(
                    index: 54, size: s + 1, color: Colors.blue.shade50)),
            Positioned(
                top: t + s * 7,
                left: l + s * 6,
                child: BoardSquare(index: 55, size: s + 1)),
            //
            Positioned(
                top: t + s * 6,
                left: l + s * 6,
                child: BoardSquare(
                    index: 4, size: s + 1, color: Colors.blue.shade100)),
            Positioned(
                top: t + s * 5,
                left: l + s * 6,
                child: BoardSquare(index: 5, size: s + 1)),
            Positioned(
                top: t + s * 4,
                left: l + s * 6,
                child: BoardSquare(index: 6, size: s + 1)),
            Positioned(
                top: t + s * 3,
                left: l + s * 6,
                child: BoardSquare(index: 7, size: s + 1)),
            Positioned(
                top: t + s * 2,
                left: l + s * 6,
                child: BoardSquare(index: 8, size: s + 1)),
            //
            Positioned(
                top: t + s * 1,
                left: l + s * 5,
                child: BoardSquare(index: 9, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 4,
                child: BoardSquare(index: 10, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 3,
                child: BoardSquare(index: 11, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 2,
                child: BoardSquare(
                    index: 12, size: s + 1, color: Colors.grey[400])),
            Positioned(
                top: t + s * 1,
                left: l + s * 1,
                child: BoardSquare(index: 13, size: s + 1)),
            Positioned(
                top: t + s * 1,
                left: l + s * 0,
                child: BoardSquare(index: 14, size: s + 1)),
            //
            Positioned(
                top: t + s * 6,
                left: l + s * 7,
                child: BoardSquare(
                    index: 56, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 5,
                left: l + s * 7,
                child: BoardSquare(
                    index: 57, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 4,
                left: l + s * 7,
                child: BoardSquare(
                    index: 58, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 3,
                left: l + s * 7,
                child: BoardSquare(
                    index: 59, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 1,
                left: l + s * 7,
                child: BoardSquare(
                    index: 61, size: s + 1, color: Colors.blue, border: false)),
            Positioned(
                top: t + s * 2,
                left: l + s * 7,
                child: BoardSquare(
                    index: 60, size: s + 1, color: Colors.blue.shade200)),
            //
            Positioned(
                top: t + s * 0,
                left: l + s * 1,
                child: BoardSquare(
                    index: 62, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t + s * 0,
                left: l + s * 2,
                child: BoardSquare(
                    index: 63, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t + s * 0,
                left: l + s * 3,
                child: BoardSquare(
                    index: 64, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t + s * 0,
                left: l + s * 4,
                child: BoardSquare(
                    index: 65, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t + s * 0,
                left: l + s * 6,
                child: BoardSquare(
                    index: 67, size: s + 1, color: Colors.red, border: false)),
            Positioned(
                top: t + s * 0,
                left: l + s * 5,
                child: BoardSquare(
                    index: 66, size: s + 1, color: Colors.red.shade200)),
            //
            Positioned(
                top: t - s * 6,
                left: l + s * 7,
                child: BoardSquare(
                    index: 68, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 5,
                left: l + s * 7,
                child: BoardSquare(
                    index: 69, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 4,
                left: l + s * 7,
                child: BoardSquare(
                    index: 70, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 3,
                left: l + s * 7,
                child: BoardSquare(
                    index: 71, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 1,
                left: l + s * 7,
                child: BoardSquare(
                    index: 73,
                    size: s + 1,
                    color: Colors.green,
                    border: false)),
            Positioned(
                top: t - s * 2,
                left: l + s * 7,
                child: BoardSquare(
                    index: 72, size: s + 1, color: Colors.green.shade200)),
            //
            Positioned(
                top: t + s * 0,
                left: l + s * 13,
                child: BoardSquare(
                    index: 74, size: s + 1, color: Colors.yellow.shade300)),
            Positioned(
                top: t + s * 0,
                left: l + s * 12,
                child: BoardSquare(
                    index: 75, size: s + 1, color: Colors.yellow.shade300)),
            Positioned(
                top: t + s * 0,
                left: l + s * 11,
                child: BoardSquare(
                    index: 76, size: s + 1, color: Colors.yellow.shade300)),
            Positioned(
                top: t + s * 0,
                left: l + s * 10,
                child: BoardSquare(
                    index: 77, size: s + 1, color: Colors.yellow.shade300)),
            Positioned(
                top: t + s * 0,
                left: l + s * 8,
                child: BoardSquare(
                    index: 79,
                    size: s + 1,
                    color: Colors.yellow,
                    border: false)),
            Positioned(
                top: t + s * 0,
                left: l + s * 9,
                child: BoardSquare(
                    index: 78, size: s + 1, color: Colors.yellow.shade300)),
            //
            Positioned(
                top: t + s * 5.5,
                left: l + s * 3,
                child: BaseSquare(
                    index: 0, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 5.5,
                left: l + s * 4,
                child: BaseSquare(
                    index: 1, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 6.5,
                left: l + s * 3,
                child: BaseSquare(
                    index: 2, size: s + 1, color: Colors.blue.shade200)),
            Positioned(
                top: t + s * 6.5,
                left: l + s * 4,
                child: BaseSquare(
                    index: 3, size: s + 1, color: Colors.blue.shade200)),
            //
            Positioned(
                top: t - s * 4,
                left: l + s * 0.5,
                child: BaseSquare(
                    index: 4, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t - s * 4,
                left: l + s * 1.5,
                child: BaseSquare(
                    index: 5, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t - s * 3,
                left: l + s * 0.5,
                child: BaseSquare(
                    index: 6, size: s + 1, color: Colors.red.shade200)),
            Positioned(
                top: t - s * 3,
                left: l + s * 1.5,
                child: BaseSquare(
                    index: 7, size: s + 1, color: Colors.red.shade200)),
            //
            Positioned(
                top: t - s * 6.5,
                left: l + s * 10,
                child: BaseSquare(
                    index: 8, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 6.5,
                left: l + s * 11,
                child: BaseSquare(
                    index: 9, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 5.5,
                left: l + s * 10,
                child: BaseSquare(
                    index: 10, size: s + 1, color: Colors.green.shade200)),
            Positioned(
                top: t - s * 5.5,
                left: l + s * 11,
                child: BaseSquare(
                    index: 11, size: s + 1, color: Colors.green.shade200)),
            //
            Positioned(
                top: t + s * 3,
                left: l + s * 12.5,
                child: BaseSquare(
                    index: 12, size: s + 1, color: Colors.yellow.shade300)),
            Positioned(
                top: t + s * 3,
                left: l + s * 13.5,
                child: BaseSquare(
                    index: 13, size: s + 1, color: Colors.yellow.shade300)),
            Positioned(
                top: t + s * 4,
                left: l + s * 12.5,
                child: BaseSquare(
                    index: 14, size: s + 1, color: Colors.yellow.shade300)),
            Positioned(
                top: t + s * 4,
                left: l + s * 13.5,
                child: BaseSquare(
                    index: 15, size: s + 1, color: Colors.yellow.shade300)),
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
          child: Opacity(
        opacity: 0.3,
        child: Obx(() {
          final role = controller.bots[player] ? 'bot' : 'player';
          final path = 'assets/images/dogs/${player}_$role.png';

          return Image.asset(
            path,
            width: size,
            height: size,
            fit: BoxFit.contain,
          );
        }),
      )),
    );
  }
}
