import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import 'credits_button.dart';
import 'help_button.dart';
import 'langaw_game.dart';

typedef void OnPressHelpButton();

class HomeScene extends BaseComponent with HasGameRef<LangawGame> {
  Component? _title;
  Component? _loseTitle;
  SpriteComponent? _startButton;
  final VoidCallback onPressStartButton;
  final VoidCallback onPressHelpButton;
  final VoidCallback onPressCreditsButton;

  HelpButton? _helpButton;

  CreditsButton? _creditsButton;

  set lost(bool value) {
    if (value) {
      addChild(_loseTitle!);
      removeChild(_title!);
    } else {
      removeChild(_loseTitle!);
      addChild(_title!);
    }
  }

  HomeScene(
      {required LangawGame game,
      required this.onPressStartButton,
      required this.onPressHelpButton,
      required this.onPressCreditsButton}) {
    gameRef = game;
  }

  Future<void> _initResources() async {
    if (_title == null) {
      var image = await Flame.images.load('branding/title.png');
      _title = SpriteComponent.fromImage(image,
          position: Vector2(
              gameRef.tileSize, (gameRef.size.y / 2) - (gameRef.tileSize * 4)),
          size: Vector2(gameRef.tileSize * 7, gameRef.tileSize * 4));
    }
    if (_loseTitle == null) {
      var image = await Flame.images.load('bg/lose-splash.png');
      _loseTitle = SpriteComponent.fromImage(image,
          position: Vector2(
              gameRef.tileSize, gameRef.size.y / 2 - gameRef.tileSize * 5),
          size: Vector2(gameRef.tileSize * 7, gameRef.tileSize * 5));
    }
    if (_startButton == null) {
      var image = await Flame.images.load('ui/start-button.png');
      _startButton = SpriteComponent.fromImage(image,
          position: Vector2(gameRef.tileSize * 1.5,
              (gameRef.size.y * .75) - (gameRef.tileSize * 1.5)),
          size: Vector2(gameRef.tileSize * 6, gameRef.tileSize * 3));
    }
  }

  @override
  Future<void>? onLoad() async {
    await _initResources();
    _helpButton = HelpButton(game: gameRef);
    addChild(_helpButton!);

    _creditsButton = CreditsButton(game: gameRef);
    addChild(_creditsButton!);

    addChild(_title!);
    addChild(_startButton!);
    await super.onLoad();
  }

  @override
  void onRemove() {
    super.onRemove();
    print('home will remove');
  }

  bool onTapUp(Offset position) {
    if (_startButton?.toRect().contains(position) ?? false) {
      onPressStartButton();
      return true;
    }
    if (_helpButton?.toRect().contains(position) ?? false) {
      onPressHelpButton();
      return true;
    }
    if (_creditsButton?.toRect().contains(position) ?? false) {
      onPressCreditsButton();
      return true;
    }
    return false;
  }
}
