import 'package:flutter_test/flutter_test.dart';
import 'package:chinczyk/controllers/game_page_controller.dart';

void main() {
  late GamePageController controller;

  setUp(() {
    controller = GamePageController()
      ..onInit();
  });

  tearDown(() {
    controller.onClose();
  });

  group('Initialization', () {
    test('board length and initial values', () {
      expect(controller.board.length, equals(80));
      expect(controller.board[0], equals(4));
      expect(controller.board[1], equals(40));
      expect(controller.board[2], equals(400));
      expect(controller.board[3], equals(4000));
      expect(controller.currentPlayer.value, equals(0));
    });

    test('regenerateBoard resets board according to positionPawns', () {
      // Move one pawn in positionPawns and regenerate
      controller.positionPawns[0] = 10;
      controller.regenerateBoard();
      expect(controller.board[10], equals(1));
      final nonZeroPositions = controller.board.asMap().entries
          .where((e) => e.key >= 4 && e.value != 0);
      expect(nonZeroPositions.length, equals(1));
    });
  });

  group('Utility functions', () {
    test('tenPow returns correct powers of ten', () {
      expect(controller.tenPow(0), equals(1));
      expect(controller.tenPow(1), equals(10));
      expect(controller.tenPow(2), equals(100));
      expect(controller.tenPow(3), equals(1000));
      expect(controller.tenPow(4), equals(0));
    });

    test('tenLog returns correct logarithm base ten index', () {
      expect(controller.tenLog(1000), equals(3));
      expect(controller.tenLog(100), equals(2));
      expect(controller.tenLog(10), equals(1));
      expect(controller.tenLog(1), equals(0));
    });
  });
}