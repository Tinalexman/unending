
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:unending/unending/actors/player.dart';

class Level1 extends World {

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    Player player = Player(character: "Ninja Frog");

    level = await TiledComponent.load("Level_01.tmx", Vector2.all(16.0));

    addAll([level, player]);
    return super.onLoad();
  }
}