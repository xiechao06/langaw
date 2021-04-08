import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'langaw_game.dart';

class LostScene extends BaseComponent with HasGameRef<LangawGame> {
  final VoidCallback onPressStartButton;
  final VoidCallback onPressHelpButton;
  final VoidCallback onPressCreditsButton;

  LostScene(
      {required LangawGame game,
      required this.onPressStartButton,
      required this.onPressHelpButton,
      required this.onPressCreditsButton}) {
    gameRef = game;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    TextPainter(
      text: TextSpan(text: "LostScene", style: TextStyle(fontSize: 64)),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, Offset.zero);
  }
}
