import 'dart:async';

import 'package:flame/components.dart';
import 'package:unending/unending/unending.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent with HasGameRef<Unending> {
  late final SpriteAnimation idleAnimation, runAnimation;
  final double stepTime = 0.05;

  final String character;

  Player({required this.character, required Vector2 position})
      : super(position: position);

  @override
  FutureOr<void> onLoad() async {
    _loadAnimations();
    return super.onLoad();
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
