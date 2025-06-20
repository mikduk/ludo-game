import 'package:get/get.dart';
import '../models/game_modes.dart';

class TeamSetupController extends GetxController {
  final List<String> colors = ['Blue', 'Red', 'Green', 'Yellow'];
  var bots = List.filled(4, false).obs;
  RxBool teamWork = false.obs;

  GameModes getGameMode() => teamWork.value ? GameModes.cooperation : GameModes.classic;

  void toggleTeamWork() {
    teamWork.value = !teamWork.value;
  }

  void toggleBotForPlayer(int playerIndex) {
    if (playerIndex >= 0 && playerIndex < bots.length) {
      bots[playerIndex] = !bots[playerIndex];
    } else {
      throw ArgumentError('Invalid player index: $playerIndex');
    }
  }
}