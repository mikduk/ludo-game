import 'package:flutter/material.dart';

class DiagonalSquare extends StatelessWidget {
  final Color color1;
  final Color color2;
  final bool isTopLeftToBottomRight; // Kierunek przekątnej

  const DiagonalSquare({
    Key? key,
    required this.color1,
    required this.color2,
    this.isTopLeftToBottomRight = true, // Domyślnie przekątna z góry-lewo na dół-prawo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(29, 29),
      painter: DiagonalPainter(
        color1: color1,
        color2: color2,
        isTopLeftToBottomRight: isTopLeftToBottomRight,
      ),
    );
  }
}

class DiagonalPainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final bool isTopLeftToBottomRight;

  DiagonalPainter({
    required this.color1,
    required this.color2,
    required this.isTopLeftToBottomRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    if (isTopLeftToBottomRight) {
      // Górny lewy -> Dolny prawy
      // Trójkąt pierwszy
      paint.color = color1;
      Path path1 = Path()
        ..moveTo(0, 0) // Lewy górny róg
        ..lineTo(size.width, 0) // Prawy górny róg
        ..lineTo(0, size.height) // Lewy dolny róg
        ..close();
      canvas.drawPath(path1, paint);

      // Trójkąt drugi
      paint.color = color2;
      Path path2 = Path()
        ..moveTo(size.width, 0) // Prawy górny róg
        ..lineTo(size.width, size.height) // Prawy dolny róg
        ..lineTo(0, size.height) // Lewy dolny róg
        ..close();
      canvas.drawPath(path2, paint);
    } else {
      // Prawy górny -> Lewy dolny
      // Trójkąt pierwszy
      paint.color = color1;
      Path path1 = Path()
        ..moveTo(size.width, 0) // Prawy górny róg
        ..lineTo(0, 0) // Lewy górny róg
        ..lineTo(size.width, size.height) // Prawy dolny róg
        ..close();
      canvas.drawPath(path1, paint);

      // Trójkąt drugi
      paint.color = color2;
      Path path2 = Path()
        ..moveTo(0, 0) // Lewy górny róg
        ..lineTo(0, size.height) // Lewy dolny róg
        ..lineTo(size.width, size.height) // Prawy dolny róg
        ..close();
      canvas.drawPath(path2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
