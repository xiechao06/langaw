import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'langaw_game.dart';

class HighScoreLabel extends PositionComponent with HasGameRef<LangawGame> {
  int? _value;
  late TextStyle _textStyle;

  TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  HighScoreLabel({required LangawGame game, required int highScore}) {
    gameRef = game;
    _value = highScore;
    var shadow = Shadow(
      blurRadius: game.tileSize * .0625,
      color: Color(0xff000000),
      offset: Offset.zero,
    );
    _textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: game.tileSize * .75,
      shadows: <Shadow>[
        shadow,
        shadow,
        shadow,
        shadow,
        shadow,
        shadow,
        shadow,
        shadow
      ],
    );
  }

  set value(int highScore) {
    _value = highScore;
    var textSpan = TextSpan(
      text: "High Score: " + _value.toString(),
      style: _textStyle,
    );
    _textPainter
      ..text = textSpan
      ..layout();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_value != null) {
      _textPainter.paint(canvas, Offset.zero.translate(8, 8));
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    var textSpan = TextSpan(
      text: "High Score: " + _value.toString(),
      style: _textStyle,
    );
    _textPainter
      ..text = textSpan
      ..layout();
  }
}
