import 'package:flutter/material.dart';
import 'package:mosquinator_0/game_controller.dart';

class StartText {
  final GameController gameController;
  TextPainter? painter;
  Offset? position;

  StartText(this.gameController) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    position = Offset.zero;
  }

  void render(Canvas c) {
    painter?.paint(c, position!);
  }

  void update(double t) {
    painter?.text = TextSpan(
      text: 'Start',
      style: TextStyle(
        color: Colors.black,
        fontSize: 50.0,
      ),
    );
    painter?.layout();

    position = Offset(
      (gameController.screenSize.width / 2) - (painter?.width ?? 0.0) / 2,
      (gameController.screenSize.height * 0.4) - (painter?.height ?? 0.0) / 2,
    );
  }
}
