import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:unending/unending/components/player.dart';

class Level extends World {
  final String levelName;
  final Player player;

  Level({
    required this.levelName,
    required this.player,
  });

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    level = await TiledComponent.load(
      "$levelName.tmx",
      Vector2.all(16.0),
    );

    ObjectGroup? spawnPointsLayer =
        level.tileMap.getLayer<ObjectGroup>("Spawn Points");
    for (TiledObject spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case "Player":
          {
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          }
        default:
      }
    }

    add(level);
  }
}
