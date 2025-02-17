import 'package:chinczyk/controllers/game_page_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  late GamePageController controller;

  setUp(() {
    controller = GamePageController();
    controller.onInit();
  });

  tearDown(() {
    controller.onClose();
  });

  // test('Inicjalizacja planszy', () {
  //   expect(controller.board.length, 80);
  //   expect(controller.board[0], 4);
  //   expect(controller.currentPlayer.value, 0);
  // });
  //
  // test('Rzut kostką i wynik 5 lub 6', () async {
  //   await controller.rollDice(player: 0);
  //   expect(controller.score.value, inInclusiveRange(1, 6));
  // });
  //
  // test('Ruch pionka na początkowe pole', () async {
  //   expect(controller.board[0], 4);
  //   await controller.rollDice(player: 0, possibilities: 1);
  //   expect(controller.score.value, 6);
  //   expect(controller.scores.value, '6');
  //   await controller.movePawn();
  //   expect(controller.board[0], 3);
  // });
  //
  // test('Zbicie pionka przeciwnika', () async {
  //   controller.board[1] = 30;
  //   controller.board[10] = 10;
  //   expect(controller.kills.value, 0);
  //   await controller.goToField(10, 1);
  //   expect(controller.board[10], 1);
  //   expect(controller.board[1], 40);
  // });
  //
  // test('Zbicie pionka przeciwnika [2]', () async {
  //   controller.board[1] = 30;
  //   controller.board[10] = 10;
  //   expect(controller.kills.value, 0);
  //   await controller.capture(10, 1);
  //   expect(controller.board[1], 40);
  //   expect(controller.kills.value, 1);
  // });
  //
  // test('Przejście do kolejnego gracza', () {
  //   List<String> players = controller.colors;
  //   for (int test = 0; test < 8; test++) {
  //     expect(controller.currentPlayer.value, players[test % players.length]);
  //     controller.getNextPlayer();
  //   }
  // });

  // test('Funkcja `whereToGo` poprawnie liczy nowe pole', () {
  //   int newPosition = controller.whereToGo(5, 6, 0);
  //   expect(newPosition, 11);
  // });
  //
  // test('Funkcja `whereToGo` gracz Red', () async {
  //   expect(controller.currentPlayer.value, 0);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 1);
  //
  //   expect(controller.board[1], 40);
  //   expect(controller.board[17], 0);
  //
  //   await controller.rollDice(player: 1, possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[1], 30);
  //   expect(controller.board[17], 10);
  //
  //   await controller.rollDice(player: 1, possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[1], 30);
  //   expect(controller.board[17], 0);
  //   expect(controller.board[23], 10);
  //
  // });
  //
  // test('Funkcja `whereToGo` gracz Green', () async {
  //   expect(controller.currentPlayer.value, 0);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 1);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 2);
  //
  //   expect(controller.board[2], 400);
  //   expect(controller.board[30], 0);
  //
  //   await controller.rollDice(player: 2, possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[2], 300);
  //   expect(controller.board[30], 100);
  //
  //   await controller.rollDice(player: 2, possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[2], 300);
  //   expect(controller.board[30], 0);
  //   expect(controller.board[36], 100);
  //
  // });
  //
  // test('Funkcja `whereToGo` gracz Yellow', () async {
  //   expect(controller.currentPlayer.value, 0);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 1);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 2);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 3);
  //
  //   expect(controller.board[3], 4000);
  //   expect(controller.board[43], 0);
  //
  //   await controller.rollDice(player: 3, possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[43], 1000);
  //
  //   await controller.rollDice(player: 3, possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[43], 0);
  //   expect(controller.board[49], 1000);
  //
  // });

  // test('Funkcja `whereToGo` gracz Yellow [extra]', () async {
  //   expect(controller.currentPlayer.value, 0);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 1);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 2);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 3);
  //
  //   expect(controller.board[3], 4000);
  //   expect(controller.board[43], 0);
  //
  //   await controller.rollDice(player: 3, possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[43], 1000);
  //
  //   await controller.rollDice(player: 3, possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[43], 0);
  //   expect(controller.board[49], 1000);
  //
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 0);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 1);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 2);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 3);
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[43], 0);
  //   expect(controller.board[49], 1000);
  //
  //   await controller.rollDice(player: 3, possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[49], 0);
  //   expect(controller.board[55], 1000);
  //
  //   await controller.rollDice(player: 3, possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[55], 0);
  //   expect(controller.board[9], 1000);
  //
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 0);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 1);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 2);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 3);
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[55], 0);
  //   expect(controller.board[9], 1000);
  //
  //   await controller.rollDice(player: 3, possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[9], 0);
  //   expect(controller.board[15], 1000);
  //
  //   await controller.rollDice(player: 3, possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[15], 0);
  //   expect(controller.board[21], 1000);
  //
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 0);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 1);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 2);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 3);
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[15], 0);
  //   expect(controller.board[21], 1000);
  //
  //   await controller.rollDice(player: 3, possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[21], 0);
  //   expect(controller.board[27], 1000);
  //
  //   await controller.rollDice(player: 3, possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[27], 0);
  //   expect(controller.board[33], 1000);
  //
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 0);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 1);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 2);
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 3);
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[27], 0);
  //   expect(controller.board[33], 1000);
  //
  //   await controller.rollDice(player: 3, possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[33], 0);
  //   expect(controller.board[39], 1000);
  //
  //   await controller.rollDice(player: 3, possibilities: 1);
  //   await controller.movePawn();
  //
  //   controller.showBoard();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[39], 0);
  //   expect(controller.board[77], 1000);
  //
  // });

  test('Funkcja `whereToGo` gracz Blue [extra]', () async {
    expect(controller.currentPlayer.value, 0);

    await goOutAndRun(controller);

    for (int i = 4; i <= 28; i += 12)
    {
      skipTurnOfAnotherPlayers(controller);

      expect(controller.board[0], 3);
      expect(controller.board[i], 0);
      expect(controller.board[i+6], 1);
      expect(controller.positionPawns[0], i+6);

      await controller.rollDice(player: 0, possibilities: 1);
      await controller.movePawn();

      expect(controller.board[0], 3);
      expect(controller.board[i+6], 0);
      expect(controller.board[i+12], 1);
      expect(controller.positionPawns[0], i+12);

      await controller.rollDice(player: 0, possibilities: 1);
      await controller.movePawn();

      expect(controller.board[0], 3);
      expect(controller.board[i+12], 0);
      expect(controller.board[i+18], 1);
      expect(controller.positionPawns[0], i+18);
    }

    skipTurnOfAnotherPlayers(controller);

    expect(controller.board[0], 3);
    expect(controller.board[40], 0);
    expect(controller.board[46], 1);
    expect(controller.positionPawns[0], 46);

    await controller.rollDice(player: 0, possibilities: 1);
    await controller.movePawn();

    expect(controller.board[0], 3);
    expect(controller.board[46], 0);
    expect(controller.board[52], 1);
    expect(controller.positionPawns[0], 52);

    await controller.rollDice(player: 0, possibilities: 1);
    await controller.movePawn();

    expect(controller.board[0], 3);
    expect(controller.board[52], 0);
    expect(controller.board[59], 1);
    expect(controller.positionPawns[0], 59);

  });

  // test('Funkcja `everyoneInBase` sprawdza bazę', () {
  //   expect(controller.board[0], 4);
  //   expect(controller.board[1], 40);
  //   expect(controller.board[2], 400);
  //   expect(controller.board[3], 4000);
  //
  //   for (int test = 0; test < 8; test++) {
  //     expect(controller.everyoneInBase(), true);
  //     controller.getNextPlayer();
  //   }
  // });
  //
  // test('Funkcja `tenPow` działa poprawnie', () {
  //   expect(controller.tenPow(0), 1);
  //   expect(controller.tenPow(1), 10);
  //   expect(controller.tenPow(2), 100);
  //   expect(controller.tenPow(3), 1000);
  //   expect(controller.tenPow(4), 0);
  // });
  //
  // test('Funkcja `tenLog` działa poprawnie', () {
  //   expect(controller.tenLog(1000), 3);
  //   expect(controller.tenLog(10), 1);
  // });

  test('Zbijanie', () async {
    controller.board[1] = 30;
    controller.board[11] = 10;
    controller.positionPawns[4] = 11;

    expect(controller.currentPlayer.value, 0);

    await goOutAndRun(controller);

    expect(controller.currentPlayer.value, 0);
    expect(controller.kills.value, 0);
    expect(controller.scores.value, '66');

    await controller.rollDice(player: 0, result: 1);
    await controller.movePawn();

    expect(controller.scores.value, '661');
    expect(controller.processedCapture.value, true);
    expect(controller.currentPlayer.value, 0);

    expect(controller.positionPawns[4], 1);
    expect(controller.board[11], 1);
    expect(controller.board[1], 40);

    await controller.rollDice(player: 0, result: 6);
    await controller.movePawn();

    expect(controller.board[0], 3);
    expect(controller.board[17], 1);
    expect(controller.positionPawns[0], 17);

    await controller.rollDice(player: 0, result: 3);
    await controller.movePawn();

    expect(controller.board[0], 3);
    expect(controller.board[20], 1);
    expect(controller.positionPawns[0], 20);

    expect(controller.currentPlayer.value, 1);
    expect(controller.nextPlayer.value, 2);
    expect(controller.scores.value, '');
    expect(controller.score.value, 0);
    expect(controller.waitForMove.value, false);

  });
}

Future<void> goOutAndRun(GamePageController controller) async {
  expect(controller.board[0], 4);
  expect(controller.board[4], 0);
  expect(controller.positionPawns[0], 0);

  await controller.rollDice(player: 0, possibilities: 1);
  await controller.movePawn();

  expect(controller.board[0], 3);
  expect(controller.board[4], 1);
  expect(controller.positionPawns[0], 4);

  await controller.rollDice(player: 0, possibilities: 1);
  await controller.movePawn();

  expect(controller.board[0], 3);
  expect(controller.board[4], 0);
  expect(controller.board[10], 1);
  expect(controller.positionPawns[0], 10);
}

void skipTurnOfAnotherPlayers(GamePageController controller,
    {List<int> players = const [1, 2, 3, 0]}) {
  for (int player in players) {
    controller.getNextPlayer();
    expect(controller.currentPlayer.value, player);
  }
}

