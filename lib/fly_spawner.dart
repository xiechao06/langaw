import 'dart:math';

import 'package:faker/faker.dart';

import 'components/sprite_fly.dart';
import 'config.dart';
import 'langaw_game.dart';

class FlySpawner {
  LangawGame game;
  void Function(SpriteFly) onSpawn;
  int nextSpawnAt = pow(2, 53).toInt();
  int flySpawnInterval = 0;
  OnFlyDismissed onFlyDismissed;
  static final rnd = Random();
  static final faker = Faker();

  FlySpawner(
      {required this.game,
      required this.onSpawn,
      required this.onFlyDismissed});

  get _livingFlyNum => game.components
      .where((element) => element is SpriteFly && !element.isDead)
      .toList()
      .length;

  void start() {
    _clear();
    flySpawnInterval = config.initialFlySpawnInterval;
    nextSpawnAt = DateTime.now().millisecondsSinceEpoch + flySpawnInterval;
  }

  void _clear() {
    game.components.where((element) => element is SpriteFly).forEach((element) {
      (element as SpriteFly).isDead = true;
    });
  }

  void update(double t) {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now >= nextSpawnAt && _livingFlyNum < config.maxFliesOnScreen) {
      _generateRandomFly().then(onSpawn);
      if (flySpawnInterval > config.minFlySpawnInterval) {
        flySpawnInterval = (flySpawnInterval * 0.8).toInt();
      }
      nextSpawnAt = now + flySpawnInterval;
      print("nextSpawnAt: $nextSpawnAt");
    }
  }

  Future<SpriteFly> _generateRandomFly() => SpriteFly.genFly(
          game: game,
          name: faker.person.firstName(),
          onFlyDismissed: onFlyDismissed,
          kind: [
            'agile',
            'drooler',
            'house',
            'hungry',
            'macho'
          ][rnd.nextInt(5)])
      .then((fly) => fly
        ..x = rnd.nextDouble() * (game.size.x - game.tileSize)
        ..y = rnd.nextDouble() * (game.size.y - game.tileSize));
}
