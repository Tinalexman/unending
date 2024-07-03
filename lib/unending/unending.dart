import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:unending/unending/levels/level_1.dart';

class Unending extends FlameGame {

  late final CameraComponent cam;
  final Level1 level = Level1();


  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(
      world: level,
      width: 640,
      height: 368,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, level]);




    return super.onLoad();
  }
}