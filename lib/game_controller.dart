import 'dart:math';
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mosquinator_0/components/background.dart';
import 'package:mosquinator_0/components/enemy.dart';
import 'package:mosquinator_0/components/enemy2.dart';
import 'package:mosquinator_0/components/health_bar.dart';
import 'package:mosquinator_0/components/highscore_text.dart';
import 'package:mosquinator_0/components/player.dart';
import 'package:mosquinator_0/components/score_text.dart';
import 'package:mosquinator_0/components/start_text.dart';
import 'package:mosquinator_0/components/totalscore_text.dart';
import 'package:mosquinator_0/enemy2_spawner.dart';
import 'package:mosquinator_0/enemy_spawner.dart';
import 'package:mosquinator_0/state.dart' as mosquinator_0;
import 'package:shared_preferences/shared_preferences.dart';

class GameController extends FlameGame {
  final SharedPreferences storage;
  Random? rand;
  Size screenSize = Size.zero;
  double tileSize = 0.0;
  Player? player;
  Background? background;
  EnemySpawner? enemySpawner;
  EnemySpawner2? enemySpawner2;
  List<Enemy>? enemies;
  List<Enemy2>? enemies2;
  HealthBar? healthBar;
  int score = 0;
  ScoreText? scoreText;
  mosquinator_0.State? state;
  HighscoreText? highscoreText;
  TotalscoreText? totalscoreText;
  StartText? startText;

  GameController(this.storage) {
    initialize();
  }

  void initialize() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      final size = WidgetsBinding.instance!.window.physicalSize /
          WidgetsBinding.instance!.window.devicePixelRatio;
      if (size != null) {
        resize(size);
      }

      state = mosquinator_0.State.menu;
      rand = Random();
      player = Player(this);
      background = Background(this);
      enemies = <Enemy>[];
      enemies2 = <Enemy2>[];
      enemySpawner = EnemySpawner(this);
      enemySpawner2 = EnemySpawner2(this);
      healthBar = HealthBar(this);
      score = 0;
      scoreText = ScoreText(this);
      totalscoreText = TotalscoreText(this);
      highscoreText = HighscoreText(this);
      startText = StartText(this);
    });
  }

  void render(Canvas c) {
    background?.render(c);

    player?.render(c);
    if (state == mosquinator_0.State.menu) {
      startText?.render(c);
      totalscoreText?.render(c);
      highscoreText?.render(c);
    } else if (state == mosquinator_0.State.playing) {
      enemies?.forEach((Enemy enemy) => enemy.render(c));
      enemies2?.forEach((Enemy2 enemy2) => enemy2.render(c));
      scoreText?.render(c);
      healthBar?.render(c);
    }
  }

  void update(double t) {
    background?.update(t);
    if (state == mosquinator_0.State.menu) {
      startText?.update(t);
      totalscoreText?.update(t);
      highscoreText?.update(t);
    } else if (state == mosquinator_0.State.playing) {
      enemySpawner?.update(t);
      enemySpawner2?.update(t);
      enemies?.forEach((Enemy enemy) => enemy.update(t));
      enemies?.removeWhere((Enemy enemy) => enemy.isDead);
      enemies2?.forEach((Enemy2 enemy2) => enemy2.update(t));
      enemies2?.removeWhere((Enemy2 enemy2) => enemy2.isDead);
      player?.update(t);
      scoreText?.update(t);
      healthBar?.update(t);
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 10;
  }

  void onTapDown(TapDownDetails d) {
    if (state == mosquinator_0.State.menu) {
      state = mosquinator_0.State.playing;
    } else if (state == mosquinator_0.State.playing) {
      //enemy1
      enemies?.forEach((Enemy enemy) {
        if (enemy.enemyRect.contains(d.globalPosition)) {
          enemy.onTapDown();
        }
      });
      //enemy2
      enemies2?.forEach((Enemy2 enemy2) {
        if (enemy2.enemyRect.contains(d.globalPosition)) {
          enemy2.onTapDown();
        }
      });
    }
  }

  void spawnEnemy() {
    //enemy1
    double x = 0.0;
    double y = 0.0;

    switch (rand?.nextInt(3)) {
      case 0:
      // spawn from Top
        x = rand!.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;

      case 1:
      // spawn from Right
        x = screenSize.width + tileSize * 2.5;
        y = rand!.nextDouble() * (screenSize.height / 2.5);
        break;

      case 2:
      // spawn from Left
        x = -tileSize * 2.5;
        y = rand!.nextDouble() * (screenSize.height / 2.5);
        break;
    }
    enemies?.add(Enemy(this, x, y));
  }

  void spawnEnemy2() {
    //enemy2
    double x = 0.0;
    double y = 0.0;

    switch (rand?.nextInt(3)) {
      case 0:
      // spawn from Top
        x = rand!.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;

      case 1:
      // spawn from Right
        x = screenSize.width + tileSize * 2.5;
        y = rand!.nextDouble() * (screenSize.height / 2.5);
        break;

      case 2:
      // spawn from Left
        x = -tileSize * 2.5;
        y = rand!.nextDouble() * (screenSize.height / 2.5);
        break;
    }
    enemies2?.add(Enemy2(this, x, y));
  }
}
