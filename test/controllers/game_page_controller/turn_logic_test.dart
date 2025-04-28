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

  group('Turn cycling', () {
    test('getNextPlayer cycles through 0-3 correctly', () {
      for (int i = 0; i < 8; i++) {
        expect(controller.currentPlayer.value, equals(i % 4));
        controller.getNextPlayer();
      }
    });
  });

  test('endTurn advances or holds turn appropriately', () async {
    expect(controller.currentPlayer.value, equals(0));
    expect(controller.nextPlayer.value, equals(1));
    // Simple advance: no kill, no six
    controller.score.value = 3;
    await controller.endTurn();
    expect(controller.waitForMove.value, isFalse);
    // Next player should be 1
    expect(controller.currentPlayer.value, equals(1));
    expect(controller.nextPlayer.value, equals(2));
  });
}