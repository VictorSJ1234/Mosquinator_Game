import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mosquinator_0/game_controller.dart';

class TotalscoreText {
  final GameController gameController;
  TextPainter? painter;
  Offset? position;

  TotalscoreText(this.gameController) {
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
    int totalscore = gameController.storage.getInt('totalscore') ?? 0;
    painter?.text = TextSpan(
      text: 'Your Score: $totalscore',
      style: TextStyle(
        color: Colors.black,
        fontSize: 40.0,
      ),
    );
    painter?.layout();

    position = Offset(
      (gameController.screenSize.width / 2) - (painter?.width ?? 0.0) / 2,
      (gameController.screenSize.height * 0.3) - (painter?.height ?? 0.0) / 2,
    );
  }
}
