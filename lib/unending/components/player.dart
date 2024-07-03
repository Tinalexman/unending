import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:unending/unending/components/collision_block.dart';
import 'package:unending/unending/components/utils.dart';
import 'package:unending/unending/unending.dart';

enum PlayerState { idle, running, jumping, falling }

class Player extends SpriteAnimationGroupComponent with HasGameRef<Unending> {
  final String character;

  Player({
    this.character = "Ninja Frog",
    super.position,
  }) {
    // debugMode = true;
  }

  late final SpriteAnimation idleAnimation,
      runAnimation,
      jumpAnimation,
      fallAnimation;

  final double stepTime = 0.05;

  final double _gravity = 9.8;
  final double _jumpForce = 460;
  final double _terminalVelocity = 300;
  double moveSpeed = 100.0;
  double horizontalMovement = 0.0;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false, hasJumped = false;

  List<CollisionBlock> blocks = [];
  PlayerHitBox hitBox = const PlayerHitBox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );

  @override
  FutureOr<void> onLoad() async {
    _loadAnimations();
    add(RectangleHitbox(
      position: Vector2(hitBox.offsetX, hitBox.offsetY),
      size: Vector2(hitBox.width, hitBox.height),
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkHorizontalCollisions();
    _checkGravity(dt);
    _checkVerticalCollisions();
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
    jumpAnimation = _createAnimation(
      "Main Characters/$character/Jump (32x32).png",
      1,
    );
    fallAnimation = _createAnimation(
      "Main Characters/$character/Fall (32x32).png",
      1,
    );

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runAnimation,
      PlayerState.falling: fallAnimation,
      PlayerState.jumping: jumpAnimation,
    };

    current = PlayerState.idle; // Set current animation
  }

  void _updatePlayerState() {
    PlayerState state = PlayerState.idle;
    if ((velocity.x < 0 && scale.x > 0) || (velocity.x > 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x > 0 || velocity.x < 0) {
      state = PlayerState.running;
    }

    if (velocity.y > 0) {
      state = PlayerState.falling;
    }
    if (velocity.y < 0) {
      state = PlayerState.jumping;
    }

    current = state;
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) {
      _playerJump(dt);
    }

    // if(velocity.y < _gravity) {
    //   isOnGround = false;
    // }

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _checkHorizontalCollisions() {
    for (CollisionBlock block in blocks) {
      if (!block.isPlatform && checkCollisions(this, block)) {
        if (velocity.x > 0) {
          velocity.x = 0;
          position.x = block.x - hitBox.offsetX - hitBox.width;
        } else if (velocity.x < 0) {
          velocity.x = 0;
          position.x = block.x + block.width + hitBox.width + hitBox.offsetX;
        }
        break;
      }
    }
  }

  void _checkVerticalCollisions() {
    for (CollisionBlock block in blocks) {
      if (checkCollisions(this, block)) {
        if (block.isPlatform) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitBox.height - hitBox.offsetY;
            isOnGround = true;
            break;
          }
        } else {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitBox.height - hitBox.offsetY;
            isOnGround = true;
          } else if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitBox.offsetY;
          }

          break;
        }
      }
    }
  }

  void _checkGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
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

class PlayerHitBox {
  final double offsetX, offsetY, width, height;

  const PlayerHitBox({
    required this.offsetX,
    required this.offsetY,
    required this.width,
    required this.height,
  });
}
