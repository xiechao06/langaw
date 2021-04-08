import 'dart:math';
import 'dart:ui';

import 'package:faker/faker.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'credits_scene.dart';
import 'dismissable.dart';
import 'fly_spawner.dart';
import 'help_scene.dart';
import 'high_score_label.dart';
import 'home_scene.dart';
import 'playing_scene.dart';

const highScoreKey = 'high_score_key';

class LangawGame extends BaseGame with TapDetector {
  late double tileSize;
  static final rnd = Random();
  static final faker = Faker();
  late HomeScene _homeScene;
  late var _playingScene;
  int score = 0;
  late FlySpawner flySpawner;
  SharedPreferences? storage;
  final _highScore = ValueNotifier(0);

  HighScoreLabel? _highScoreLabel;

  late HelpScene _helpScene;
  late CreditsScene _creditsScene;

  LangawGame() {
    flySpawner = FlySpawner(
      game: this,
      onSpawn: add,
      onFlyDismissed: (spriteFly) {
        score++;
        if (score > (storage?.getInt(highScoreKey) ?? 0)) {
          storage?.setInt(highScoreKey, score);
          _highScore.value = score;
        }
      },
    );
    _homeScene = HomeScene(
      game: this,
      onPressStartButton: _startGame,
      onPressHelpButton: () {
        activeScene = (_helpScene..previousScene = activeScene);
      },
      onPressCreditsButton: () =>
          activeScene = (_creditsScene..previousScene = activeScene),
    );
    _helpScene = HelpScene(
      game: this,
      onClose: (previousScene) {
        activeScene = previousScene;
      },
    );
    _creditsScene = CreditsScene(
        game: this, onClose: (previousScene) => activeScene = previousScene);
    _playingScene = PlayingScene()..gameRef = this;
  }

  Component? _activeScene;

  set activeScene(Component value) {
    if (_activeScene != null) {
      remove(_activeScene!);
    }
    _activeScene = value;
    add(value);
  }

  Component get activeScene => _activeScene!;

  bool get isPlaying => activeScene == _playingScene;

  @override
  void update(double dt) {
    super.update(dt);
    if (activeScene == _playingScene) {
      flySpawner.update(dt);
    }
  }

  @override
  void onTapUp(details) {
    if (activeScene == _homeScene) {
      if (_homeScene.onTapUp(details.globalPosition)) {
        return;
      }
    }
    if (activeScene == _helpScene) {
      _helpScene.onTapUp();
      return;
    }
    if (activeScene == _creditsScene) {
      _creditsScene.onTapUp();
      return;
    }
    Iterable<Dismissable> shouldDissmiss = components
        .where((element) => (element is Dismissable))
        .cast<Dismissable>()
        .where((element) => (element as PositionComponent)
            .toRect()
            .contains(details.globalPosition));
    if (shouldDissmiss.isNotEmpty) {
      shouldDissmiss.forEach((element) {
        element.dismiss();
        FlameAudio.play('sfx/ouch' + (rnd.nextInt(11) + 1).toString() + '.ogg');
      });
    } else {
      FlameAudio.play('sfx/haha' + (rnd.nextInt(5) + 1).toString() + '.ogg');
      activeScene = _homeScene..lost = true;
      FlameAudio.bgm.play('bgm/home.mp3', volume: .5);
    }
  }

  void _startGame() {
    score = 0;
    activeScene = _playingScene;
    flySpawner.start();
    FlameAudio.bgm.play('bgm/playing.mp3', volume: .5);
  }

  @override
  Future<void> onLoad() async {
    add(await _loadBackgroundImage());
    activeScene = _homeScene;
    FlameAudio.bgm.play('bgm/home.mp3');
    storage = await SharedPreferences.getInstance();
    _highScore.value = storage?.getInt(highScoreKey) ?? 0;
    _highScoreLabel = HighScoreLabel(game: this, highScore: _highScore.value);
    _highScore.addListener(() {
      _highScoreLabel?.value = _highScore.value;
    });
    add(_highScoreLabel!);
    await super.onLoad();
  }

  Future<Component> _loadBackgroundImage() async {
    var backyardImage = await Flame.images.load("bg/backyard.png");
    var srcWidth = backyardImage.width.toDouble();
    var srcHeight = size.y * backyardImage.width.toDouble() / size.x;
    return SpriteComponent.fromImage(backyardImage,
        size: size,
        srcSize: Vector2(srcWidth, srcHeight),
        srcPosition: Vector2(0, backyardImage.height - srcHeight));
  }

  @override
  void onResize(Vector2 size) {
    super.onResize(size);
    tileSize = size.x / 9;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = Color(0xff576574));
    super.render(canvas);
  }
}
