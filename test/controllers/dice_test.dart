import 'package:flutter_test/flutter_test.dart';
import 'package:chinczyk/controllers/game_page_controller.dart';

void main() {
  late GamePageController controller;

  setUp(() async {
    controller = GamePageController()
      ..onInit();
  });

  tearDown(() {
    controller.onClose();
  });

  group('Dice rolling', () {
    test('getRandomValue returns between 1 and 6', () {
      for (int i = 0; i < 100; i++) {
        int val = GamePageController.getRandomValue(6, null);
        expect(val, inInclusiveRange(1, 6));
      }
    });

    test(
        'rollDice updates score and statisticRolls for current player', () async {
      controller.rollDice(player: 0);
      expect(controller.currentPlayer.value, 0);
      if (controller.currentPlayer.value == 0) {
        expect(controller.score.value, inInclusiveRange(1, 6));
        int idx = 6 * 0 + (controller.score.value - 1);
        expect(controller.statisticRolls[idx], greaterThanOrEqualTo(1));
      } else {
        expect(controller.score.value, 0);
      }
    });

    test('rollDice respects custom possibilities and forced result', () async {
      // Force a result via parameter
      controller.rollDice(player: 0, possibilities: 3, result: 2);
      expect(controller.score.value, equals(2));
      // Index for statisticRolls should correspond to the forced result
      int idx = (2 - 1);
      expect(controller.statisticRolls[idx], greaterThanOrEqualTo(1));
    });

    test('rollDice for non-current player does nothing', () async {
      // currentPlayer is 0
      await controller.rollDice(player: 1);
      expect(controller.score.value, equals(0));
    });
  });
}