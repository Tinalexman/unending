import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/widgets.dart';
import 'package:unending/unending/components/level.dart';
import 'package:unending/unending/components/player.dart';

class Unending extends FlameGame with DragCallbacks {
  late final CameraComponent cam;
  late JoystickComponent joystick;

  Player player = Player(character: "Mask Dude");

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    await images.loadAllImages();
    Level level = Level(
      levelName: "Level_01",
      player: player,
    );

    cam = CameraComponent.withFixedResolution(
      world: level,
      width: 640,
      height: 368,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    add(cam);
    add(level);
    _addJoysticks();
  }

  @override
  void update(double dt) {
    _updateJoystick();
    super.update(dt);
  }

  void _addJoysticks() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache("HUD/Knob.png"),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache("HUD/Joystick.png"),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 40),
    );
    HudButtonComponent jumpButton = HudButtonComponent(
      button: SpriteComponent(
        sprite: Sprite(
          images.fromCache("HUD/JumpButton.png"),
        ),
      ),
      onPressed: () {
        if (!player.hasJumped) {
          player.hasJumped = true;
        }
      },
      onReleased: () {
        if(player.hasJumped) {
          player.hasJumped = false;
        }
      },
      margin: const EdgeInsets.only(right: 32, bottom: 40),
    );

    add(joystick);
    add(jumpButton);
  }

  void _updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1.0;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1.0;
        break;
      default:
        player.horizontalMovement = 0.0;
        break;
    }
  }
}
