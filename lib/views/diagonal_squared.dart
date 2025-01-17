import 'package:flutter/material.dart';

class DiagonalSquare extends StatelessWidget {
  final Color color1;
  final Color color2;
  final bool isTopLeftToBottomRight;
  final bool showTopBorder;
  final bool showBottomBorder;
  final bool showLeftBorder;
  final bool showRightBorder;

  const DiagonalSquare({
    Key? key,
    required this.color1,
    required this.color2,
    this.isTopLeftToBottomRight = true,
    this.showTopBorder = true,
    this.showBottomBorder = true,
    this.showLeftBorder = true,
    this.showRightBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(29, 29),
      painter: DiagonalPainter(
        color1: color1,
        color2: color2,
        isTopLeftToBottomRight: isTopLeftToBottomRight,
        showTopBorder: showTopBorder,
        showBottomBorder: showBottomBorder,
        showLeftBorder: showLeftBorder,
        showRightBorder: showRightBorder,
      ),
    );
  }
}

class DiagonalPainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final bool isTopLeftToBottomRight;
  final bool showTopBorder;
  final bool showBottomBorder;
  final bool showLeftBorder;
  final bool showRightBorder;

  DiagonalPainter({
    required this.color1,
    required this.color2,
    required this.isTopLeftToBottomRight,
    required this.showTopBorder,
    required this.showBottomBorder,
    required this.showLeftBorder,
    required this.showRightBorder,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    // Rysowanie przekątnego podziału
    if (isTopLeftToBottomRight) {
      // Górny lewy -> Dolny prawy
      paint.color = color1;
      Path path1 = Path()
        ..moveTo(0, 0) // Lewy górny róg
        ..lineTo(size.width, 0) // Prawy górny róg
        ..lineTo(0, size.height) // Lewy dolny róg
        ..close();
      canvas.drawPath(path1, paint);

      paint.color = color2;
      Path path2 = Path()
        ..moveTo(size.width, 0) // Prawy górny róg
        ..lineTo(size.width, size.height) // Prawy dolny róg
        ..lineTo(0, size.height) // Lewy dolny róg
        ..close();
      canvas.drawPath(path2, paint);
    } else {
      // Prawy górny -> Lewy dolny
      paint.color = color1;
      Path path1 = Path()
        ..moveTo(size.width, 0) // Prawy górny róg
        ..lineTo(0, 0) // Lewy górny róg
        ..lineTo(size.width, size.height) // Prawy dolny róg
        ..close();
      canvas.drawPath(path1, paint);

      paint.color = color2;
      Path path2 = Path()
        ..moveTo(0, 0) // Lewy górny róg
        ..lineTo(0, size.height) // Lewy dolny róg
        ..lineTo(size.width, size.height) // Prawy dolny róg
        ..close();
      canvas.drawPath(path2, paint);
    }

    // Rysowanie czarnej ramki
    paint.color = Colors.black;
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;

    Path borderPath = Path();

    if (showTopBorder) {
      borderPath.moveTo(0, 0); // Lewy górny róg
      borderPath.lineTo(size.width, 0); // Prawy górny róg
    }
    if (showRightBorder) {
      borderPath.moveTo(size.width, 0); // Prawy górny róg
      borderPath.lineTo(size.width, size.height); // Prawy dolny róg
    }
    if (showBottomBorder) {
      borderPath.moveTo(size.width, size.height); // Prawy dolny róg
      borderPath.lineTo(0, size.height); // Lewy dolny róg
    }
    if (showLeftBorder) {
      borderPath.moveTo(0, size.height); // Lewy dolny róg
      borderPath.lineTo(0, 0); // Lewy górny róg
    }

    canvas.drawPath(borderPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
