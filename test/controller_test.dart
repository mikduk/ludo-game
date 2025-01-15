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
  //   expect(controller.currentPlayer.value, 'Blue');
  // });
  //
  // test('Rzut kostką i wynik 5 lub 6', () async {
  //   await controller.rollDice(player: 'Blue');
  //   expect(controller.score.value, inInclusiveRange(1, 6));
  // });
  //
  // test('Ruch pionka na początkowe pole', () async {
  //   expect(controller.board[0], 4);
  //   await controller.rollDice(player: 'Blue', possibilities: 1);
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
  //   expect(controller.currentPlayer.value, 'Blue');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Red');
  //
  //   expect(controller.board[1], 40);
  //   expect(controller.board[17], 0);
  //
  //   await controller.rollDice(player: 'Red', possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[1], 30);
  //   expect(controller.board[17], 10);
  //
  //   await controller.rollDice(player: 'Red', possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[1], 30);
  //   expect(controller.board[17], 0);
  //   expect(controller.board[23], 10);
  //
  // });
  //
  // test('Funkcja `whereToGo` gracz Green', () async {
  //   expect(controller.currentPlayer.value, 'Blue');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Red');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Green');
  //
  //   expect(controller.board[2], 400);
  //   expect(controller.board[30], 0);
  //
  //   await controller.rollDice(player: 'Green', possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[2], 300);
  //   expect(controller.board[30], 100);
  //
  //   await controller.rollDice(player: 'Green', possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[2], 300);
  //   expect(controller.board[30], 0);
  //   expect(controller.board[36], 100);
  //
  // });
  //
  // test('Funkcja `whereToGo` gracz Yellow', () async {
  //   expect(controller.currentPlayer.value, 'Blue');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Red');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Green');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Yellow');
  //
  //   expect(controller.board[3], 4000);
  //   expect(controller.board[43], 0);
  //
  //   await controller.rollDice(player: 'Yellow', possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[43], 1000);
  //
  //   await controller.rollDice(player: 'Yellow', possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[43], 0);
  //   expect(controller.board[49], 1000);
  //
  // });

  // test('Funkcja `whereToGo` gracz Yellow [extra]', () async {
  //   expect(controller.currentPlayer.value, 'Blue');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Red');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Green');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Yellow');
  //
  //   expect(controller.board[3], 4000);
  //   expect(controller.board[43], 0);
  //
  //   await controller.rollDice(player: 'Yellow', possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[43], 1000);
  //
  //   await controller.rollDice(player: 'Yellow', possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[43], 0);
  //   expect(controller.board[49], 1000);
  //
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Blue');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Red');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Green');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Yellow');
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[43], 0);
  //   expect(controller.board[49], 1000);
  //
  //   await controller.rollDice(player: 'Yellow', possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[49], 0);
  //   expect(controller.board[55], 1000);
  //
  //   await controller.rollDice(player: 'Yellow', possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[55], 0);
  //   expect(controller.board[9], 1000);
  //
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Blue');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Red');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Green');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Yellow');
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[55], 0);
  //   expect(controller.board[9], 1000);
  //
  //   await controller.rollDice(player: 'Yellow', possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[9], 0);
  //   expect(controller.board[15], 1000);
  //
  //   await controller.rollDice(player: 'Yellow', possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[15], 0);
  //   expect(controller.board[21], 1000);
  //
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Blue');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Red');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Green');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Yellow');
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[15], 0);
  //   expect(controller.board[21], 1000);
  //
  //   await controller.rollDice(player: 'Yellow', possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[21], 0);
  //   expect(controller.board[27], 1000);
  //
  //   await controller.rollDice(player: 'Yellow', possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[27], 0);
  //   expect(controller.board[33], 1000);
  //
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Blue');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Red');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Green');
  //   controller.getNextPlayer();
  //   expect(controller.currentPlayer.value, 'Yellow');
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[27], 0);
  //   expect(controller.board[33], 1000);
  //
  //   await controller.rollDice(player: 'Yellow', possibilities: 1);
  //   await controller.movePawn();
  //
  //   expect(controller.board[3], 3000);
  //   expect(controller.board[33], 0);
  //   expect(controller.board[39], 1000);
  //
  //   await controller.rollDice(player: 'Yellow', possibilities: 1);
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
    expect(controller.currentPlayer.value, 'Blue');

    expect(controller.board[0], 4);
    expect(controller.board[4], 0);

    await controller.rollDice(player: 'Blue', possibilities: 1);
    await controller.movePawn();

    expect(controller.board[0], 3);
    expect(controller.board[4], 1);

    await controller.rollDice(player: 'Blue', possibilities: 1);
    await controller.movePawn();

    expect(controller.board[0], 3);
    expect(controller.board[4], 0);
    expect(controller.board[10], 1);

    controller.getNextPlayer();
    expect(controller.currentPlayer.value, 'Red');
    controller.getNextPlayer();
    expect(controller.currentPlayer.value, 'Green');
    controller.getNextPlayer();
    expect(controller.currentPlayer.value, 'Yellow');
    controller.getNextPlayer();
    expect(controller.currentPlayer.value, 'Blue');

    expect(controller.board[0], 3);
    expect(controller.board[4], 0);
    expect(controller.board[10], 1);

    await controller.rollDice(player: 'Blue', possibilities: 1);
    await controller.movePawn();

    expect(controller.board[0], 3);
    expect(controller.board[10], 0);
    expect(controller.board[16], 1);

    await controller.rollDice(player: 'Blue', possibilities: 1);
    await controller.movePawn();

    expect(controller.board[0], 3);
    expect(controller.board[16], 0);
    expect(controller.board[22], 1);

    controller.getNextPlayer();
    expect(controller.currentPlayer.value, 'Red');
    controller.getNextPlayer();
    expect(controller.currentPlayer.value, 'Green');
    controller.getNextPlayer();
    expect(controller.currentPlayer.value, 'Yellow');
    controller.getNextPlayer();
    expect(controller.currentPlayer.value, 'Blue');

    expect(controller.board[0], 3);
    expect(controller.board[16], 0);
    expect(controller.board[22], 1);

    await controller.rollDice(player: 'Blue', possibilities: 1);
    await controller.movePawn();

    expect(controller.board[0], 3);
    expect(controller.board[22], 0);
    expect(controller.board[28], 1);

    await controller.rollDice(player: 'Blue', possibilities: 1);
    await controller.movePawn();

    expect(controller.board[0], 3);
    expect(controller.board[28], 0);
    expect(controller.board[34], 1);

    controller.getNextPlayer();
    expect(controller.currentPlayer.value, 'Red');
    controller.getNextPlayer();
    expect(controller.currentPlayer.value, 'Green');
    controller.getNextPlayer();
    expect(controller.currentPlayer.value, 'Yellow');
    controller.getNextPlayer();
    expect(controller.currentPlayer.value, 'Blue');

    expect(controller.board[0], 3);
    expect(controller.board[28], 0);
    expect(controller.board[34], 1);

    await controller.rollDice(player: 'Blue', possibilities: 1);
    await controller.movePawn();

    expect(controller.board[0], 3);
    expect(controller.board[34], 0);
    expect(controller.board[40], 1);

    await controller.rollDice(player: 'Blue', possibilities: 1);
    await controller.movePawn();

    expect(controller.board[0], 3);
    expect(controller.board[40], 0);
    expect(controller.board[46], 1);

    controller.getNextPlayer();
    expect(controller.currentPlayer.value, 'Red');
    controller.getNextPlayer();
    expect(controller.currentPlayer.value, 'Green');
    controller.getNextPlayer();
    expect(controller.currentPlayer.value, 'Yellow');
    controller.getNextPlayer();
    expect(controller.currentPlayer.value, 'Blue');

    expect(controller.board[0], 3);
    expect(controller.board[40], 0);
    expect(controller.board[46], 1);

    await controller.rollDice(player: 'Blue', possibilities: 1);
    await controller.movePawn();

    expect(controller.board[0], 3);
    expect(controller.board[46], 0);
    expect(controller.board[52], 1);

    await controller.rollDice(player: 'Blue', possibilities: 1);
    await controller.movePawn();

    controller.showBoard();

    expect(controller.board[0], 3);
    expect(controller.board[52], 0);
    expect(controller.board[59], 1);

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
}
