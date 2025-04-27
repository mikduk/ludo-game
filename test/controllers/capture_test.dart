import 'package:flutter_test/flutter_test.dart';
import 'package:chinczyk/controllers/game_page_controller.dart';

void main() {
  late GamePageController controller;

  setUp(() {
    controller = GamePageController()
      ..onInit();
    controller.soundOn.value = false;
  });

  tearDown(() {
    controller.onClose();
  });

  group('Capture logic', () {
    test('canCapture returns false on safe fields', () {
      expect(controller.canCapture(4, 1), isFalse);
      expect(controller.canCapture(12, 10), isFalse);
    });

    test('capture moves opponent pawn home and updates kills/deaths', () async {
      // Setup: place Blue pawn at 10 and Red pawn at 10
      controller.board[1] = 30;
      controller.board[10] = 10;
      controller.positionPawns[4 * 1 + 0] = 10;
      // Blue captures
      await controller.capture(10, 1);
      // Pawn returned to base
      expect(controller.board[10], equals(1));
      // Base for Red (index 1) is position 1
      expect(controller.board[1], equals(40));
      expect(controller.kills.value, equals(1));
      expect(controller.statisticDeaths[1], equals(1));
      expect(controller.statisticKills[0], equals(1));
    });
  });

  group('Capture logic with team and solo modes', () {
    setUp(() {
      controller.initializeBoard();
    });

    test('canCapture in solo mode - self fire prevention', () {
      controller.teamWork.value = false;
      controller.board[10] = 1;
      expect(controller.canCapture(10, 1), isFalse);
    });

    test('canCapture in team mode - self fire prevention', () {
      controller.teamWork.value = true;
      controller.board[10] = 1;
      expect(controller.canCapture(10, 1), isFalse);
    });

    test('canCapture in solo mode', () {
      controller.teamWork.value = false;
      controller.board[10] = 1;
      expect(controller.canCapture(10, 100), isTrue);
    });

    test('canCapture in team mode - friendly fire prevention', () {
      controller.teamWork.value = true;
      controller.board[10] = 1;
      expect(controller.canCapture(10, 100), isFalse);
    });

    test('canCapture in team mode - enemy capture', () {
      controller.teamWork.value = true;
      controller.board[10] = 1;
      expect(controller.canCapture(10, 10), isTrue);
    });

    test('capture updates stats correctly in solo mode', () async {
      controller.teamWork.value = false;
      controller.board[1] = 30;
      controller.board[10] = 10;
      controller.positionPawns[4] = 10;
      await controller.capture(10, 1);
      expect(controller.kills.value, equals(1));
      expect(controller.statisticKills[0], equals(1));
      expect(controller.statisticDeaths[1], equals(1));
    });

    test('capture updates stats correctly in team mode', () async {
      controller.teamWork.value = true;
      controller.board[1] = 30;
      controller.board[10] = 10;
      controller.positionPawns[4] = 10;
      await controller.capture(10, 1);
      expect(controller.kills.value, equals(1));
      expect(controller.statisticKills[0], equals(1));
      expect(controller.statisticDeaths[1], equals(1));
    });
  });

  group('Yellow attacks different field configurations', () {
    setUp(() {
      controller.initializeBoard();
    });

    test('Yellow attacks field with Yellow and Blue - solo mode', () async {
      controller.teamWork.value = false;
      controller.board[40] = 1000 + 1; // Yellow (1000) + Blue (1)

      bool canCapture = controller.canCapture(40, 1000);
      expect(canCapture, isTrue); // Solo: Yellow może zbić Blue

      await controller.capture(40, 1000);
      expect(controller.board[40], greaterThan(1000));
    });

    test('Yellow attacks field with Yellow and Blue - team mode', () async {
      controller.teamWork.value = true;
      controller.board[40] = 1000 + 1; // Yellow (1000) + Blue (1)

      bool canCapture = controller.canCapture(40, 1000);
      expect(canCapture, isFalse); // Team: Yellow i Blue są w jednej drużynie
    });

    test('Yellow attacks field with two Greens - solo mode', () async {
      controller.teamWork.value = false;
      controller.board[41] = 100 + 100; // 2x Green (100)

      bool canCapture = controller.canCapture(41, 1000);
      expect(canCapture, isTrue); // Solo: Yellow może bić Green

      await controller.capture(41, 1000);
      expect(controller.board[41], greaterThan(1000));
    });

    test('Yellow attacks field with two Greens - team mode', () async {
      controller.teamWork.value = true;
      controller.board[41] = 100 + 100; // 2x Green (100)

      bool canCapture = controller.canCapture(41, 1000);
      expect(canCapture, isTrue); // Team: Yellow i Green są przeciwnikami

      await controller.capture(41, 1000);
      expect(controller.board[41], greaterThan(1000));
    });

    test('Yellow attacks field with Green and Blue - solo mode', () async {
      controller.teamWork.value = false;
      controller.board[42] = 100 + 1; // Green + Blue

      bool canCapture = controller.canCapture(42, 1000);
      expect(canCapture, isTrue); // Solo: Yellow może zbić Green

      await controller.capture(42, 1000);
      expect(controller.board[42], greaterThan(1000));
    });

    test('Yellow attacks field with Green and Blue - team mode', () async {
      controller.teamWork.value = true;
      controller.board[42] = 100 + 1; // Green + Blue

      bool canCapture = controller.canCapture(42, 1000);
      expect(canCapture, isTrue); // Team: Yellow bije Green (wroga drużyna)

      await controller.capture(42, 1000);
      expect(controller.board[42], greaterThan(1000));
    });

    test('Yellow attacks field with Green and Red - solo mode', () async {
      controller.teamWork.value = false;
      controller.board[43] = 100 + 10; // Green + Red

      bool canCapture = controller.canCapture(43, 1000);
      expect(canCapture, isTrue); // Solo: Yellow może zbić Green lub Red

      await controller.capture(43, 1000);
      expect(controller.board[43], greaterThan(1000));
    });

    test('Yellow attacks field with Green and Red - team mode', () async {
      controller.teamWork.value = true;
      controller.board[43] = 100 + 10; // Green + Red

      bool canCapture = controller.canCapture(43, 1000);
      expect(canCapture, isTrue); // Team: Yellow może zbić Green lub Red

      await controller.capture(43, 1000);
      expect(controller.board[43], greaterThan(1000));
    });
  });

  group('Yellow attacks on safe fields', () {
    setUp(() {
      controller.initializeBoard();
    });

    test('Yellow cannot capture enemy on safe field in solo mode', () {
      controller.teamWork.value = false;
      controller.board[4] = 100; // Green (enemy)

      bool canCapture = controller.canCapture(4, 1000);
      expect(canCapture, isFalse); // Bo pole 4 jest bezpieczne
    });

    test('Yellow cannot capture enemy on safe field in team mode', () {
      controller.teamWork.value = true;
      controller.board[4] = 100; // Green (enemy)

      bool canCapture = controller.canCapture(4, 1000);
      expect(canCapture, isFalse); // Bo pole 4 jest bezpieczne
    });

    test('Yellow cannot capture friendly on safe field in solo mode', () {
      controller.teamWork.value = false;
      controller.board[12] = 1; // Blue (friendly)

      bool canCapture = controller.canCapture(12, 1000);
      expect(canCapture, isFalse); // Nie można bić na bezpiecznym polu
    });

    test('Yellow cannot capture friendly on safe field in team mode', () {
      controller.teamWork.value = true;
      controller.board[12] = 1; // Blue (friendly)

      bool canCapture = controller.canCapture(12, 1000);
      expect(canCapture, isFalse); // Nie można bić na bezpiecznym polu
    });

    test('Yellow cannot capture multiple enemies on safe field', () {
      controller.teamWork.value = false;
      controller.board[17] = 100 + 10; // Green + Red

      bool canCapture = controller.canCapture(17, 1000);
      expect(canCapture, isFalse); // Nadal nie można – bezpieczne pole
    });

    test('Yellow cannot capture mixed players on safe field in team mode', () {
      controller.teamWork.value = true;
      controller.board[17] = 100 + 10; // Green + Red

      bool canCapture = controller.canCapture(17, 1000);
      expect(canCapture, isFalse);
    });
  });
}