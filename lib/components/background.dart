import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:mosquinator_0/game_controller.dart';

class Background {
  final GameController gameController;

  SpriteAnimationComponent? backgroundSprite;

  Background(this.gameController) {
    Flame.images.load('background/backyard_1.png').then((image) {
      final spriteSize = Vector2(32, 32); // Set the size of each sprite frame

      final spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: image,
        columns: 30, // Set the number of columns in your spritesheet
        rows: 5, // Set the number of rows in your spritesheet
      );

      final spriteAnimation = spriteSheet.createAnimation(
        row: 0, // Set the row index of the animation frames
        stepTime: 0.1, // Set the duration between each frame (adjust as desired)
        to: 149, // Set the number of frames in your spritesheet
        loop: true,
      );

      backgroundSprite = SpriteAnimationComponent(
        animation: spriteAnimation,
        size: Vector2(
          gameController.screenSize.width,
          gameController.screenSize.height,
        ),
      );
    });
  }

  void render(Canvas c) {
    backgroundSprite?.render(c);
  }

  void update(double t) {
    backgroundSprite?.update(t);
  }
}
