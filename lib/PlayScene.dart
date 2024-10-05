import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
class PlayScene extends Forge2DGame {
  final int numberOfBalls;
  final PlanetType planet;

  PlayScene({required this.numberOfBalls, required this.planet})
  :super(gravity: Vector2(0, planet.gravity));

  

  @override
  Future<void> onLoad() async {
    super.onLoad();

    //바닥과 블랙홀 추가
    addGround();
    addBlackhole();

    //공들 생성
    createBalls();
  }

  void createBalls() {
    final screenWidth = size.x;
    final screenHeight = size.y;
    final ballColors = [
      Colors.red, Colors.orange, Colors.green, Colors.purple,
      Colors.yellow, Colors.cyan, Colors.lightGreen, Colors.blue,
    ];

    for (int i = 0; i < numberOfBalls; i++) {
      final ball = BallComponent(
        position: Vector2(screenWidth / 2 + i.toDouble(), screenHeight * 0.9),
        color: ballColors[i % ballColors.length],
      );
      add(ball);
    }
  }

  void addGround() {
    final screenSize = size;
    //왼쪽바닥
    add(GroundCOm)
  }

  @override
  void update(double dt) {
    super.update(dt);


  }
}


class GroundComponent extends RectangleComponent {
  GroundComponent(Vector2 position, bool isLeft): super(size: Vector2(200, 10), position: position, paint: Paint().. color = Colors.brown) {
    body  = BodyComponent()..createBody(BodyDef(position: position, type: BodyType.static));
  }
}

class BlackholeComponent extends Circle

class PlanetType {
  final double gravity;
  final double duration;
  final String caption;

  PlanetType({
    required this.gravity,
    required this.duration,
    required this.caption,
  });

  static PlanetType earth = PlanetType(
    gravity: -9.81,
    duration: 1.0,
    caption: "창백한 푸른 점.",
  );

  static PlanetType moon = PlanetType(
    gravity: -1.62,
    duration: 2.5,
    caption: "FLY ME TO THE MOON.",
  );

  static PlanetType mustafar = PlanetType(
    gravity: -0.4,
    duration: 3.0,
    caption: "IT'S OVER ANAKIN.",
  );

  static PlanetType uranus = PlanetType(
    gravity: -8.69,
    duration: 1.5,
    caption: "천왕성, 얼음 거인.",
  );
}