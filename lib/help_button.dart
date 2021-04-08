import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import 'langaw_game.dart';

class HelpButton extends SpriteComponent with HasGameRef<LangawGame> {
  HelpButton({required LangawGame game}) {
    gameRef = game;
    x = game.tileSize * .25;
    y = game.size.y - game.tileSize * 1.25;
    width = game.tileSize;
    height = game.tileSize;
  }

  @override
  Future<void>? onLoad() async {
    sprite = Sprite(await Flame.images.load('ui/icon-help.png'));
    await super.onLoad();
  }
}
