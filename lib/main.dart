import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unending/unending/unending.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.fullScreen();
  Flame.device.setLandscape();

  Unending unending = Unending();
  runApp(GameWidget(game: kDebugMode ? Unending() : unending));
}


