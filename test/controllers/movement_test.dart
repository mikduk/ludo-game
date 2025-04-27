import 'package:flutter_test/flutter_test.dart';
import 'package:chinczyk/controllers/game_page_controller.dart';

void main() {
  late GamePageController controller;

  setUp(() {
    controller = GamePageController()..onInit();
  });


  tearDown(() {
    controller.onClose();
  });

  group('whereToGo logic', () {
    test('Blue moves from 5 by 6 to 11', () {
      int newPos = controller.whereToGo(5, 6, 0);
      expect(newPos, equals(11));
    });

    test('Red moves from base to start on roll 6', () async {
      controller.getNextPlayer();
      int newPos = controller.whereToGo(1, 6, 1);
      expect(newPos, equals(1 * 13 + 4));
    });

    test('Green moves correctly on final path to home', () async {
      controller.getNextPlayer();
      controller.getNextPlayer();
      int newPos = controller.whereToGo(55, 1, 2);
      expect(newPos, equals(4));
    });

    test('Yellow wraps from 55 back to 4', () async {
      controller.getNextPlayer();
      controller.getNextPlayer();
      controller.getNextPlayer();
      int newPos = controller.whereToGo(55, 1, 3);
      expect(newPos, equals(4));
    });

    test('Yellow handles overshooting finish', () async {
      int playerIndex = 3;
      for (final _ in Iterable.generate(playerIndex)) {
        controller.getNextPlayer();
      }
      int oldPos = 60 + playerIndex * 6;
      int newPos = controller.whereToGo(oldPos, 6, playerIndex);
      expect(newPos, equals(oldPos)); // can't move if overshoots
    });

    test('Green moves properly inside home stretch', () async {
      int playerIndex = 2;
      for (final _ in Iterable.generate(playerIndex)) {
        controller.getNextPlayer();
      }
      int oldPos = 56 + playerIndex * 6;
      int newPos = controller.whereToGo(oldPos, 2, playerIndex);
      expect(newPos, equals(oldPos + 2));
    });
  });
}