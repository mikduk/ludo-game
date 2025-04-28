import 'package:flutter_test/flutter_test.dart';
import 'package:chinczyk/controllers/game_page_controller.dart';
import 'package:chinczyk/controllers/sound_controller.dart';
import 'package:get/get.dart';

void main() {
  late GamePageController controller;

  setUp(() {
    Get.testMode = true;
    Get.put(SoundController());
    controller = GamePageController()..onInit();
    controller.soundOn.value = false;
  });

  tearDown(() {
    controller.onClose();
  });

  group('getOpponentPow logic', () {
    test('No opponent present', () {
      int result = 0; // Pole puste
      int pow = controller.getOpponentPow(1, result);
      expect(pow, equals(0));
    });

    test('Only self on the field (solo mode)', () {
      int attacker = 1; // Blue
      int result = 1; // tylko Blue na polu
      int pow = controller.getOpponentPow(attacker, result);
      expect(pow, equals(0));
    });

    test('Enemy present - solo mode', () {
      int attacker = 1; // Blue
      int result = 10; // Red na polu
      controller.teamWork.value = false;
      int pow = controller.getOpponentPow(attacker, result);
      expect(pow, equals(10)); // powinien wskazać Reda
    });

    test('Enemy present - team mode', () {
      int attacker = 10; // Red
      int result = 100; // Green na polu
      controller.teamWork.value = true;
      int pow = controller.getOpponentPow(attacker, result);
      expect(pow, equals(100)); // powinien wskazać Green (wróg)
    });

    test('Friendly pawn ignored - team mode', () {
      int attacker = 1; // Blue
      int result = 1; // Blue na polu
      controller.teamWork.value = true;
      int pow = controller.getOpponentPow(attacker, result);
      expect(pow, equals(0)); // nie zbija swojego
    });

    test('Friendly team mate ignored - team mode', () {
      int attacker = 1; // Blue
      int result = 100; // Yellow na polu (teammate)
      controller.teamWork.value = true;
      int pow = controller.getOpponentPow(attacker, result);
      expect(pow, equals(0)); // nie zbija sojusznika
    });

    test('Multiple players on field - no capture', () {
      int attacker = 1000; // Yellow
      int result = 1 + 100 + 10; // Blue + Green + Red
      controller.teamWork.value = false;
      int pow = controller.getOpponentPow(attacker, result);
      expect(pow, equals(0));
    });

    test('Multiple players on field - skip teammate in team mode', () {
      int attacker = 1000; // Yellow
      int result = 1 + 100 + 10; // Blue + Green + Red
      controller.teamWork.value = true;
      int pow = controller.getOpponentPow(attacker, result);
      expect(pow, equals(0));
    });

    test('Enemy in last position', () {
      int attacker = 1; // Blue
      int result = 1000; // tylko Yellow na polu
      controller.teamWork.value = false;
      int pow = controller.getOpponentPow(attacker, result);
      expect(pow, equals(1000)); // zbija Yellowa
    });

    test('Self and enemy - should ignore self and find enemy', () {
      int attacker = 1; // Blue
      int result = 1 + 10; // Blue + Red
      controller.teamWork.value = false;
      int pow = controller.getOpponentPow(attacker, result);
      expect(pow, equals(10)); // powinien wybrać Reda
    });
  });
}
