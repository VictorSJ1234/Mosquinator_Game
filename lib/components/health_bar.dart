import 'dart:ui';

import 'package:mosquinator_0/game_controller.dart';

class HealthBar {
  final GameController gameController;
  Rect healthBarRect = Rect.zero;
  Rect remainingHealthRect = Rect.zero;

  HealthBar(this.gameController) {
    double barWidth = gameController.screenSize.width / 1.75;
    healthBarRect = Rect.fromLTWH(
      gameController.screenSize.width / 2 - barWidth / 2,
      gameController.screenSize.height * 0.1,
      barWidth,
      gameController.tileSize * 0.5,
    );
    remainingHealthRect = Rect.fromLTWH(
      gameController.screenSize.width / 2 - barWidth / 2,
      gameController.screenSize.height * 0.1,
      barWidth,
      gameController.tileSize * 0.5,
    );
  }

  void render(Canvas c) {
    Paint healthBarColor = Paint()..color = Color(0xFFFF0000);
    Paint remainingBarColor = Paint()..color = Color(0xFF00FF00);
    c.drawRect(healthBarRect, healthBarColor);
    c.drawRect(remainingHealthRect, remainingBarColor);
  }

  void update(double t) {
    double barWidth = gameController.screenSize.width / 1.75;
    double percentHealth = gameController.player!.currentHealth / gameController.player!.maxHealth;
    remainingHealthRect = Rect.fromLTWH(
      gameController.screenSize.width / 2 - barWidth / 2,
      gameController.screenSize.height * 0.1,
      barWidth * percentHealth,
      gameController.tileSize * 0.5,
    );
  }
}
