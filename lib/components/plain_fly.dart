import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import '../dismissable.dart';
import '../langaw_game.dart';

class PlainFly extends PositionComponent
    with HasGameRef<LangawGame>, Dismissable {
  final flyPaint = PaletteEntry(Color(0xff6ab04c)).paint();
  String name;

  bool isDead = false;

  PlainFly({required this.name});

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), flyPaint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) {
      y += gameRef.tileSize * 12 * dt;
      if (y > gameRef.size.y) {
        print("fly $name is offscreen");
        shouldRemove = true;
      }
    }
  }

  @override
  void onMount() {
    super.onMount();
    width = gameRef.tileSize;
    height = gameRef.tileSize;
  }

  @override
  void dismiss() {
    print("fly $name will be dimissed");
    flyPaint.color = Color(0xffff4757);
    isDead = true;
  }
}
