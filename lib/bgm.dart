import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class _BGM {
  late AudioCache home;

  late AudioCache playing;

  BGMType? currentBGMType;

  Future<void> preload() async {
    if (kIsWeb) {
      return;
    }
    home = AudioCache(fixedPlayer: AudioPlayer());
    await home.load('audio/bgm/home.mp3');
    await home.fixedPlayer?.setReleaseMode(ReleaseMode.LOOP);

    playing = AudioCache(fixedPlayer: AudioPlayer());
    await home.load('audio/bgm/playing.mp3');
    await playing.fixedPlayer?.setReleaseMode(ReleaseMode.LOOP);
  }

  Future<void> play(BGMType bgmType) async {
    if (kIsWeb) {
      return;
    }
    if (currentBGMType != bgmType) {
      currentBGMType = bgmType;
      switch (bgmType) {
        case BGMType.home:
          await playing.fixedPlayer?.stop();
          await home.loop('audio/bgm/home.mp3', volume: .25);
          break;
        case BGMType.playing:
          await home.fixedPlayer?.stop();
          await playing.loop('audio/bgm/playing.mp3', volume: .25);
          break;
        default:
      }
    }
  }
}

final bgm = _BGM();

enum BGMType { home, playing }
