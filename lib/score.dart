import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'langaw_game.dart';

class Score extends PositionComponent with HasGameRef<LangawGame> {
  late var textStyle;
  TextPainter? textPainter;

  Score(LangawGame game) {
    gameRef = game;
    textStyle = TextStyle(
        color: Colors.white,
        fontSize: gameRef.tileSize * 2,
        shadows: [
          Shadow(
              blurRadius: gameRef.tileSize * .25,
              color: Colors.red,
              offset: Offset(3, 3))
        ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _setupTextPainter();
  }

  void _setupTextPainter() {
    if (textPainter?.text?.toPlainText() != gameRef.score.toString()) {
      textPainter = TextPainter(
          text: TextSpan(text: gameRef.score.toString(), style: textStyle),
          textDirection: TextDirection.ltr)
        ..layout();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    textPainter?.paint(canvas, Offset(0, 0));
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    _setupTextPainter();
    x = gameRef.size.x / 2 - textPainter!.width / 2;
    y = gameRef.size.y * .25 - textPainter!.height / 2;
  }
}
