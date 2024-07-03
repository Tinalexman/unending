import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:unending/unending/components/collision_block.dart';
import 'package:unending/unending/components/player.dart';

class Level extends World {
  final String levelName;
  final Player player;

  Level({
    required this.levelName,
    required this.player,
  });

  late TiledComponent level;
  final List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    level = await TiledComponent.load(
      "$levelName.tmx",
      Vector2.all(16.0),
    );

    add(level);

    ObjectGroup? collisionsLayer =
        level.tileMap.getLayer<ObjectGroup>("Collisions");
    if (collisionsLayer != null) {
      for (TiledObject collisionPoint in collisionsLayer.objects) {
        switch (collisionPoint.class_) {
          case "Platform":
            CollisionBlock platform = CollisionBlock(
              position: Vector2(collisionPoint.x, collisionPoint.y),
              size: Vector2(collisionPoint.width, collisionPoint.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            CollisionBlock block = CollisionBlock(
              position: Vector2(collisionPoint.x, collisionPoint.y),
              size: Vector2(collisionPoint.width, collisionPoint.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }

    ObjectGroup? spawnPointsLayer =
    level.tileMap.getLayer<ObjectGroup>("Spawn Points");

    if (spawnPointsLayer != null) {
      for (TiledObject spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case "Player":
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;

          default:
        }
      }
    }

    player.blocks = collisionBlocks;
  }
}
