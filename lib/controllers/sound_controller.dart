import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class SoundController extends GetxController {

  RxBool soundOn = true.obs;
  late final FlutterSoundPlayer _player;
  final Map<String, String> _soundPaths = {};
  static const _allSounds = <String>[
    'bravo',
    'capture',
    'complete',
    'congratulations',
    'end',
    'fail_roll',
    'false_success_fail',
    'goOut',
    'laugh1',
    'laugh2'
  ];

  @override
  void onInit() {
    super.onInit();
    _player = FlutterSoundPlayer();
    _player.openPlayer();
    _initSounds();
  }

  Future<void> _initSounds() async {
    final tmp = await getTemporaryDirectory();
    for (final key in _allSounds) {
      final bytes = await rootBundle.load('assets/sounds/$key.mp3');
      final file = File('${tmp.path}$key.mp3');
      await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
      _soundPaths[key] = file.path;
    }
  }

  @override
  void onClose() {
    _player.closePlayer();
    super.onClose();
  }

  void soundSwitch() {
    soundOn.value = !soundOn.value;
    if (soundOn.value) {
      playRandomSound();
    }
  }

  void playRandomSound() {
    if (!soundOn.value) return;
    final i = Random().nextInt(_allSounds.length);
    _playByKey(_allSounds[i]);
  }

  void playRandomlyLaugh() {
    if (Random().nextInt(10) >= 9) {
      final laughKeys = ['laugh1', 'laugh2'];
      _playByKey(laughKeys[Random().nextInt(laughKeys.length)]);
    }
  }

  void playRandomlyCongrats() {
    if (Random().nextInt(100) >= 92) {
      _playByKey('congratulations');
    }
  }

  void playBravoSound() => _playByKey('bravo');

  void playCaptureSound() => _playByKey('capture');

  void playCompleteSound() => _playByKey('complete');

  void playEndSound() => _playByKey('end');

  void playFailRollSound() => _playByKey('fail_roll');

  void playFalseSuccessFailSound() => _playByKey('false_success_fail');

  void playGoOutSound() => _playByKey('goOut');

  Future<void> _playByKey(String key) async {
    if (!soundOn.value) return;
    final path = _soundPaths[key]!;
    await _player.startPlayer(
      fromURI: path,
      codec: Codec.mp3,
    );
  }
}