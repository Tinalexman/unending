import 'package:unending/unending/components/collision_block.dart';
import 'package:unending/unending/components/player.dart';

bool checkCollisions(Player player, CollisionBlock block) {

  PlayerHitBox hitBox = player.hitBox;

  double playerX = player.position.x + hitBox.offsetX,
      playerY = player.position.y + hitBox.offsetY;
  double playerWidth = hitBox.width, playerHeight = hitBox.height;

  double blockX = block.x, blockY = block.y;
  double blockWidth = block.width, blockHeight = block.height;

  double fixedX = player.scale.x < 0 ? playerX - (hitBox.offsetX * 2) - playerWidth : playerX;
  double fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  return (fixedY < blockY + blockHeight &&
      fixedY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}
