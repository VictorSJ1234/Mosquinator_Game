import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:mosquinator_0/game_controller.dart';

class Player extends FlameGame {
  final GameController gameController;

  // Player health
  int maxHealth = 0;
  int currentHealth = 0;
  bool isDead = false;

  // Player sprite
  ui.Image? playerImage;

  Player(this.gameController) {
    // Set initial health
    maxHealth = currentHealth = 300;

    // Load player image
    Flame.images.load('playerImage/mario2.png').then((image) {
      playerImage = image;
    });
  }

  // Image/player size and position
  Rect get playerRect {
    double scale = gameController.screenSize.width / playerImage!.width * 0.4; // 50% scale
    double x = (gameController.screenSize.width - playerImage!.width * scale) / 2; // center horizontally
    double y = gameController.screenSize.height - playerImage!.height * scale; // align to bottom
    return Rect.fromLTWH(
      x,
      y,
      playerImage!.width.toDouble() * scale,
      playerImage!.height.toDouble() * scale,
    );
  }

  void render(Canvas c) {
    // Draw the player image
    if (playerImage != null) {
      c.drawImageRect(
        playerImage!,
        Rect.fromLTWH(0, 0, playerImage!.width.toDouble(), playerImage!.height.toDouble()),
        playerRect,
        Paint(),
      );
    }
  }

  void update(double t) {
    // Check if the player is dead
    if (!isDead && currentHealth <= 0) {
      isDead = true;
      gameController.initialize();
    }
  }
}
