import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mosquinator_0/game_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the device orientation to portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //hide the statusbar and nvabar.
  //await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  SharedPreferences storage = await SharedPreferences.getInstance();
  GameController gameController = GameController(storage);
  runApp(GameWidget(game: gameController));

  //for tap gesture
  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = gameController.onTapDown;
  GestureBinding.instance!.pointerRouter.addGlobalRoute((PointerEvent event) {
    if (event is PointerDownEvent) {
      tapper.addPointer(event);
    }
  });

}
