import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import '../dismissable.dart';
import '../langaw_game.dart';

typedef void OnFlyDismissed(SpriteFly spriteFly);

class SpriteFly extends PositionComponent
    with HasGameRef<LangawGame>, Dismissable {
  late List<Sprite> flyingSprite;
  late Sprite deadSprite;
  late String name;
  int flyingSpriteCount = 0;
  bool isDead = false;
  OnFlyDismissed onFlyDismissed;

  SpriteFly(
      {required LangawGame game,
      required this.name,
      required this.flyingSprite,
      required this.deadSprite,
      required this.onFlyDismissed}) {
    gameRef = game;
  }

  static Future<SpriteFly> genFly(
      {required LangawGame game,
      required String name,
      required String kind,
      required OnFlyDismissed onFlyDismissed}) async {
    var flyingImages = await Flame.images
        .loadAll(['flies/$kind-fly-1.png', 'flies/$kind-fly-2.png']);
    var deadImage = await Flame.images.load('flies/$kind-fly-dead.png');
    return SpriteFly(
        game: game,
        name: name,
        flyingSprite: flyingImages.map((e) => Sprite(e)).toList(),
        deadSprite: Sprite(deadImage),
        onFlyDismissed: onFlyDismissed);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (isDead) {
      deadSprite.render(canvas, size: size);
    } else {
      flyingSprite[(flyingSpriteCount / 4).ceil() % 2]
          .render(canvas, size: size);
    }
  }

  @override
  void update(dt) {
    super.update(dt);
    if (isDead) {
      y += gameRef.tileSize * 12 * dt;
      if (y > gameRef.size.y) {
        print("fly $name is offscreen");
        shouldRemove = true;
      }
    } else {
      ++flyingSpriteCount;
    }
  }

  @override
  void onRemove() {
    super.onRemove();
    print("fly $name will be removed!");
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
    isDead = true;
    onFlyDismissed(this);
  }
}
