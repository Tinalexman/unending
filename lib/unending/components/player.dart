import 'dart:async';

import 'package:flame/components.dart';
import 'package:unending/unending/unending.dart';

enum PlayerState { idle, running }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent with HasGameRef<Unending> {
  final String character;

  Player({
    this.character = "Ninja Frog",
    super.position,
  });

  late final SpriteAnimation idleAnimation, runAnimation;
  final double stepTime = 0.05;
  double moveSpeed = 100.0;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;
  PlayerDirection playerDirection = PlayerDirection.none;

  @override
  FutureOr<void> onLoad() async {
    _loadAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  void _loadAnimations() {
    idleAnimation = _createAnimation(
      "Main Characters/$character/Idle (32x32).png",
      11,
    );
    runAnimation = _createAnimation(
      "Main Characters/$character/Run (32x32).png",
      12,
    );

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runAnimation,
    };

    current = PlayerState.idle; // Set current animation
  }

  void _updatePlayerMovement(double dt) {
    double directionX = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        directionX -= moveSpeed;
        current = PlayerState.running;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        directionX += moveSpeed;
        current = PlayerState.running;
        break;
      default:
        current = PlayerState.idle;
        break;
    }
    velocity = Vector2(directionX, 0.0);
    position += velocity * dt;
  }

  SpriteAnimation _createAnimation(String path, int amount) =>
      SpriteAnimation.fromFrameData(
        gameRef.images.fromCache(path),
        SpriteAnimationData.sequenced(
          amount: amount,
          stepTime: stepTime,
          textureSize: Vector2.all(32.0),
        ),
      );
}
