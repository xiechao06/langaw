import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:langaw/langaw_game.dart';
import 'package:langaw/score.dart';

class PlayingScene extends BaseComponent with HasGameRef<LangawGame> {
  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  Future<void>? onLoad() async {
    addChild(Score(gameRef));
    await super.onLoad();
  }
}
