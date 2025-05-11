import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

import 'game_page_controller.dart';

class SoundController extends GetxController {
  void playRandomSound() async {
    List<String> sounds = ['capture', 'goOut', 'bravo', 'laugh1', 'laugh2', 'complete', 'congratulations'];
    int i = Random().nextInt(sounds.length);
    playClickSound(sound: 'sounds/${sounds[i]}.mp3');
  }

  void playRandomlyLaugh() async {
    List<String> sounds = ['laugh1', 'laugh2'];
    int i = Random().nextInt(sounds.length);
    if (Random().nextInt(10) >= 9) {
      playClickSound(sound: 'sounds/${sounds[i]}.mp3');
    }
  }

  void playRandomlyCongrats() async {
    List<String> sounds = ['congratulations'];
    int i = Random().nextInt(sounds.length);
    if (Random().nextInt(100) >= 99) {
      playClickSound(sound: 'sounds/${sounds[i]}.mp3');
    }
  }

  void playClickSound({String sound = 'sounds/capture.mp3'}) async {
    final GamePageController controller = Get.find();
    if (controller.soundOn.value) {
      print('|playClickSound| sound: $sound');
      try {
        final player = AudioPlayer();
        await player.setSource(AssetSource(sound));
        await player.resume();
      } catch (e) {
        print('|playClickSound| $e');
        playClickSound(sound: 'sounds/capture.mp3');
      }
    }
  }
}