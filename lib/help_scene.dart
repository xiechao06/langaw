import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import 'langaw_game.dart';

class HelpScene extends BaseComponent with HasGameRef<LangawGame> {
  void Function(Component previousScene) onClose;
  Component? previousScene;

  HelpScene({required LangawGame game, required this.onClose}) {
    gameRef = game;
  }

  @override
  Future<void>? onLoad() async {
    addChild(SpriteComponent.fromImage(
        await Flame.images.load('ui/dialog-help.png'),
        size: Vector2(gameRef.tileSize * 8, gameRef.tileSize * 12))
      ..x = gameRef.tileSize * .5
      ..y = gameRef.size.y / 2 - gameRef.tileSize * 6);
    await super.onLoad();
  }

  void onTapUp() {
    onClose(previousScene!);
  }
}
