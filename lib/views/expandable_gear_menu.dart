import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/game_page_controller.dart';
import '../controllers/screen_controller.dart';

// -----------------------------------------------------------------------------
// 1. Kontroler animacji menu
// -----------------------------------------------------------------------------
class GearMenuController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final RxBool isOpen = false.obs;
  late final AnimationController animCtrl;
  late final Animation<double> scaleAnim;
  late final Animation<double> fadeAnim;

  @override
  void onInit() {
    super.onInit();
    animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    scaleAnim = CurvedAnimation(parent: animCtrl, curve: Curves.easeOutBack);
    fadeAnim = CurvedAnimation(parent: animCtrl, curve: Curves.easeIn);

    animCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) isOpen.value = true;
      if (status == AnimationStatus.dismissed) isOpen.value = false;
    });
  }

  void toggle() {
    if (animCtrl.isAnimating) return;
    isOpen.value ? animCtrl.reverse() : animCtrl.forward();
  }

  @override
  void onClose() {
    animCtrl.dispose();
    super.onClose();
  }
}

// -----------------------------------------------------------------------------
// 2. Model pojedynczego przycisku
// -----------------------------------------------------------------------------
class _GameActionData {
  final String heroTag;
  final Color color;
  final Widget child;
  final VoidCallback onTap;
  const _GameActionData({
    required this.heroTag,
    required this.color,
    required this.child,
    required this.onTap,
  });
}

// -----------------------------------------------------------------------------
// 3. Główny widżet menu – 8 przycisków w układzie 2 × 4
// -----------------------------------------------------------------------------
class ExpandableGameMenu extends StatelessWidget {
  final GamePageController gameController;
  final ScreenController screenController;

  // Parametry układu
  static const int kColumns = 2; // 2 kolumny
  static const double kSpacingY = 70; // pion
  static const double kSpacingX = 70; // poziom
  static const double kFabSize = 56; // średnica FAB + cień
  static const double kMargin = 16; // bufor

  const ExpandableGameMenu({
    Key? key,
    required this.gameController,
    required this.screenController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GearMenuController c = Get.put(GearMenuController());

    // --------------------- 3a. Definicje bazowe (4 przyciski) ---------------
    final List<_GameActionData> baseActions = [
      _GameActionData(
        heroTag: 'btn9',
        color: Colors.tealAccent,
        onTap: gameController.changeMode,
        child: Obx(() => gameController.teamWork.value
            ? const Icon(Icons.people)
            : const Icon(Icons.person)),
      ),
      _GameActionData(
        heroTag: 'btn10',
        color: Colors.lightBlueAccent,
        onTap: () {
          gameController.regenerateBoard();
          screenController.update();
        },
        child: const Icon(Icons.refresh),
      ),
      _GameActionData(
        heroTag: 'btn11',
        color: Colors.limeAccent,
        onTap: gameController.soundSwitch,
        child: Obx(() => gameController.soundController.soundOn.value
            ? const Icon(Icons.music_note_outlined)
            : const Icon(Icons.music_off_outlined)),
      ),
      _GameActionData(
        heroTag: 'btn12',
        color: Colors.deepOrangeAccent,
        onTap: gameController.startStopGame,
        child: Obx(() => gameController.stopGame.value
            ? const Icon(Icons.pause)
            : const Icon(Icons.play_arrow)),
      ),
    ];

    final List<int> indexes = [2, 1, 3, 0];
    final List<MaterialColor> botColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow
    ];
    final List<_GameActionData> botActions = List.generate(
        4,
        (i) => _GameActionData(
              heroTag: 'bot${indexes[i]}a',
              color: botColors[indexes[i]].shade200,
              onTap: () => gameController.changeBotFlag(indexes[i]),
              child: Obx(() => gameController.bots[indexes[i]]
                  ? const Icon(Icons.phone_android_outlined)
                  : const Icon(Icons.person_outlined)),
            ));

    // Pełna lista 8 przycisków
    final actions = <_GameActionData>[...baseActions, ...botActions];

    // --------------------- 3c. Hit‑box / wymiary ---------------------------
    final rows = (actions.length + kColumns - 1) ~/ kColumns; // =4
    final hitW = (kColumns - 1) * kSpacingX + kFabSize + kMargin;
    final hitH = rows * kSpacingY + kFabSize + kMargin;

    return Obx(() => SizedBox(
          width: hitW,
          height: hitH,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topRight,
            children: [
              if (c.isOpen.value)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child:
                        Container(color: Colors.black.withValues(alpha: 0.0)),
                  ),
                ),
              if (c.isOpen.value)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: c.toggle,
                    behavior: HitTestBehavior.opaque,
                  ),
                ),

              // ---------------- 3d. Rozmieszczenie przycisków ---------------
              for (int i = 0; i < actions.length; i++)
                _AnimatedGameAction(
                  animation: c.scaleAnim,
                  fade: c.fadeAnim,
                  top: kSpacingY * ((i ~/ kColumns) + 1),
                  right: kSpacingX * (i % kColumns),
                  data: actions[i],
                ),

              // -------------------------- Zębatka ---------------------------
              Padding(
                padding: const EdgeInsets.all(4),
                child: FloatingActionButton(
                  heroTag: 'gear',
                  shape: const CircleBorder(),
                  onPressed: c.toggle,
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: -0.25).animate(c.scaleAnim),
                    child: const Icon(Icons.settings),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

// -----------------------------------------------------------------------------
// 4. Animowany kafelek
// -----------------------------------------------------------------------------
class _AnimatedGameAction extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> fade;
  final double top;
  final double right;
  final _GameActionData data;

  const _AnimatedGameAction({
    Key? key,
    required this.animation,
    required this.fade,
    required this.top,
    required this.right,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      child: ScaleTransition(
        scale: animation,
        child: FadeTransition(
          opacity: fade,
          child: FloatingActionButton.small(
            heroTag: data.heroTag,
            backgroundColor: data.color,
            onPressed: data.onTap,
            child: data.child,
          ),
        ),
      ),
    );
  }
}
