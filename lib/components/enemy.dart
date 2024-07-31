import 'dart:ui' as ui;

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mosquinator_0/game_controller.dart';

class Enemy extends FlameGame {
  final GameController gameController;
  int health = 0;
  int damage = 0;
  double speed = 0.0;
  Rect enemyRect = Rect.zero;
  bool isDead = false;

  // Spritesheet properties
  ui.Image? spritesheet;
  int rows = 1;
  int columns = 1;
  int currentFrame = 0;
  double frameWidth = 0;
  double frameHeight = 0;
  double frameRate = 20; // Adjust this value to control the animation speed

  // New variables for animation
  double timeSinceLastFrame = 0.0;

  Enemy(this.gameController, double x, double y) {
    health = 2; // set initial health to 2
    damage = 1; // set damage to 1
    speed = gameController.tileSize * 2.5; // set speed to 2 times the tile size

    // Load spritesheet
    Flame.images.load('enemies/sample_enemy.png').then((image) {
      spritesheet = image;

      rows = 5; // specify the number of rows in the spritesheet
      columns = 24; // specify the number of columns in the spritesheet

      frameWidth = spritesheet!.width.toDouble() / columns;
      frameHeight = spritesheet!.height.toDouble() / rows;

      double scale = gameController.screenSize.width / frameWidth * 0.28; //size of the enemy

      enemyRect = Rect.fromLTWH(
        x,
        y,
        frameWidth * scale,
        frameHeight * scale,
      );
    });
  }

  void render(Canvas c) {
    if (spritesheet != null) {
      bool flipHorizontally = enemyRect.left < gameController.screenSize.width / 2.5;

      c.save(); // Save the canvas state

      // Flip the canvas horizontally if the enemy spawns from the left
      if (flipHorizontally) {
        c.translate(enemyRect.left + enemyRect.width / 2, enemyRect.top + enemyRect.height / 2);
        c.scale(-1.0, 1.0);
        c.translate(-(enemyRect.left + enemyRect.width / 2), -(enemyRect.top + enemyRect.height / 2));
      }

      c.drawImageRect(
        spritesheet!,
        Rect.fromLTWH(
          currentFrame * frameWidth,
          0,
          frameWidth,
          frameHeight,
        ),
        enemyRect,
        Paint(),
      );

      c.restore(); // Restore the canvas state
    }
  }

  void update(double t) {
    if (!isDead && spritesheet != null) {
      // Update the time since the last frame
      timeSinceLastFrame += t;

      // Calculate the time required for each frame based on the frame rate
      double frameTime = 1.0 / frameRate;

      // Check if enough time has passed to switch to the next frame
      while (timeSinceLastFrame >= frameTime) {
        // Move to the next frame
        currentFrame = (currentFrame + 1) % columns;
        timeSinceLastFrame -= frameTime;
      }

      if (!isDead) {
        // Calculate the distance the enemy can move in one frame
        double stepDistance = speed * t;

        // Calculate the vector from the enemy to the player
        Offset toPlayer =
            gameController.player!.playerRect.center - enemyRect.center;

        // Check if the enemy can move a full step towards the player
        if (stepDistance <= toPlayer.distance - gameController.tileSize * 2.25) {
          // Calculate the movement vector towards the player
          Offset stepToPlayer =
          Offset.fromDirection(toPlayer.direction, stepDistance);

          // Move the enemy towards the player
          enemyRect = enemyRect.shift(stepToPlayer);
        } else {
          // If the enemy touched the player, attack
          attack();
        }
      }
    }
  }

  void attack() {
    if (gameController.player != null && !gameController.player!.isDead) {
      gameController.player!.currentHealth -= damage;
    }
  }

  void onTapDown() {
    if (!isDead) {
      health--;
      if (health <= 0) {
        isDead = true;
        gameController.score++;
        gameController.storage.setInt('totalscore', gameController.score);
        print(gameController.score);
        if (gameController.score >
            (gameController.storage.getInt('highscore') ?? 0)) {
          gameController.storage.setInt('highscore', gameController.score);
        }
      }
    }
  }
}
