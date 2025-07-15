import 'dart:math';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soundpool/soundpool.dart';

class SoundController extends GetxController {

  RxBool soundOn = true.obs;
  late final Soundpool _pool;
  final Map<String, int> _soundIds = {};
  static const _allSounds = [
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
    _pool = Soundpool.fromOptions(
      options: const SoundpoolOptions(),
    );
    _initSounds();
  }

  Future<void> _initSounds() async {
    for (var key in _allSounds) {
      final bytes = await rootBundle.load('assets/sounds/$key.mp3');
      final id = await _pool.load(bytes);
      _soundIds[key] = id;
    }
  }

  @override
  void onClose() {
    _pool.release();
    super.onClose();
  }

  void soundSwitch() {
    soundOn.value = !soundOn.value;
    if (soundOn.value) {
      playRandomSound();
    }
  }

  void playRandomSound() {
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

  void _playByKey(String key) {
    if (!soundOn.value) return;

    final id = _soundIds[key];
    if (id != null) {
      _pool.play(id);
    } else {
      final defaultId = _soundIds['capture'];
      if (defaultId != null) _pool.play(defaultId);
    }
  }
}