import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import 'langaw_game.dart';

class CreditsButton extends SpriteComponent with HasGameRef<LangawGame> {
  CreditsButton({required LangawGame game}) {
    gameRef = game;
    x = gameRef.size.x - game.tileSize * 1.25;
    y = game.size.y - game.tileSize * 1.25;
    width = game.tileSize;
    height = game.tileSize;
  }

  @override
  Future<void>? onLoad() async {
    sprite = Sprite(await Flame.images.load('ui/icon-credits.png'));
    await super.onLoad();
  }
}
