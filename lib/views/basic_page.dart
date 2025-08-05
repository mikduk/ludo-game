import 'dart:math';
import 'package:flutter/material.dart';
import '../controllers/screen_controller.dart';

abstract class BasicPage extends StatelessWidget {
  const BasicPage({super.key});

  Widget menuButton({
    required String text,
    required VoidCallback? onPressed,
    required double shortest,
    required ScreenController c,
  }) {
    double width = 0.62 * shortest;
    double height = shortest * 0.09;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: shortest * 0.1,
          vertical: shortest * 0.02,
        ),
        fixedSize: Size(width, height),
        textStyle: TextStyle(fontSize: min(shortest * 0.04, 20)),
      ),
      child: Text(text),
    );
  }
}
