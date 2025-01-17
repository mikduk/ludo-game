import 'package:flutter/material.dart';

class FourColorSquare extends StatelessWidget {
  final Color topLeftColor;
  final Color topRightColor;
  final Color bottomLeftColor;
  final Color bottomRightColor;
  final bool showBorder; // Czy wyświetlać ramkę
  final Color borderColor;
  final double borderWidth;

  const FourColorSquare({
    super.key,
    required this.topLeftColor,
    required this.topRightColor,
    required this.bottomLeftColor,
    required this.bottomRightColor,
    this.showBorder = true, // Domyślnie ramka jest widoczna
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(29, 29),
      painter: FourColorPainter(
        topLeftColor: topLeftColor,
        topRightColor: topRightColor,
        bottomLeftColor: bottomLeftColor,
        bottomRightColor: bottomRightColor,
        showBorder: showBorder,
        borderColor: borderColor,
        borderWidth: borderWidth,
      ),
    );
  }
}

class FourColorPainter extends CustomPainter {
  final Color topLeftColor;
  final Color topRightColor;
  final Color bottomLeftColor;
  final Color bottomRightColor;
  final bool showBorder;
  final Color borderColor;
  final double borderWidth;

  FourColorPainter({
    required this.topLeftColor,
    required this.topRightColor,
    required this.bottomLeftColor,
    required this.bottomRightColor,
    required this.showBorder,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    // Trójkąt lewy górny
    paint.color = topLeftColor;
    Path topLeftPath = Path()
      ..moveTo(0, 0) // Lewy górny róg
      ..lineTo(size.width / 2, size.height / 2) // Środek
      ..lineTo(0, size.height) // Lewy dolny róg
      ..close();
    canvas.drawPath(topLeftPath, paint);

    // Trójkąt prawy górny
    paint.color = topRightColor;
    Path topRightPath = Path()
      ..moveTo(size.width, 0) // Prawy górny róg
      ..lineTo(size.width / 2, size.height / 2) // Środek
      ..lineTo(0, 0) // Lewy górny róg
      ..close();
    canvas.drawPath(topRightPath, paint);

    // Trójkąt lewy dolny
    paint.color = bottomLeftColor;
    Path bottomLeftPath = Path()
      ..moveTo(0, size.height) // Lewy dolny róg
      ..lineTo(size.width / 2, size.height / 2) // Środek
      ..lineTo(size.width, size.height) // Prawy dolny róg
      ..close();
    canvas.drawPath(bottomLeftPath, paint);

    // Trójkąt prawy dolny
    paint.color = bottomRightColor;
    Path bottomRightPath = Path()
      ..moveTo(size.width, size.height) // Prawy dolny róg
      ..lineTo(size.width / 2, size.height / 2) // Środek
      ..lineTo(size.width, 0) // Prawy górny róg
      ..close();
    canvas.drawPath(bottomRightPath, paint);

    // Ramka
    if (showBorder) {
      paint.color = borderColor;
      paint.strokeWidth = borderWidth;
      paint.style = PaintingStyle.stroke;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
