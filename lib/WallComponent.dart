import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart' as forge2d;
import 'package:flame_forge2d/flame_forge2d.dart';


class WallComponent extends forge2d.BodyComponent {
  final List<Vector2> points;
  final Vector2 position;

  WallComponent({required this.points, required this.position});

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: position,
      type: BodyType.static
    );

    final body = world.createBody(bodyDef);

    //Edgeshape 경계 셋업
    final edgeShape = ChainShape();
    edgeShape.createChain(points);

    final fixtureDef = FixtureDef(edgeShape)
    ..restitution = 2.0;

    body.createFixture(fixtureDef);

    return body;
  }
}


void addRightGround(double screenWidth, double screenHeight, Forge2DGame game) {
  // 오른쪽 벽 경계 좌표 설정
  final points = [
    Vector2(0, 0), // 화면의 하단 왼쪽
    Vector2(0, screenHeight * 0.8), // 상단을 향해 올라가는 경사
    Vector2(screenWidth * -0.2, screenHeight * 0.9),
    Vector2(screenWidth * -0.35, screenHeight * 0.92),
    Vector2(screenWidth * -0.46, screenHeight * 0.94),
    Vector2(screenWidth * -0.46, screenHeight), // 화면 상단에 맞게
  ];

  // WallComponent를 추가
  final rightWall = WallComponent(points: points, position: Vector2(screenWidth, 0));
  game.add(rightWall);
}

void addLeftGround(double screenWidth, double screenHeight, Forge2DGame game) {
  // 왼쪽 벽 경계 좌표 설정
  final points = [
    Vector2(0, 0), // 화면의 하단 오른쪽
    Vector2(0, screenHeight * 0.8), // 상단을 향해 올라가는 경사
    Vector2(screenWidth * 0.2, screenHeight * 0.9),
    Vector2(screenWidth * 0.35, screenHeight * 0.92),
    Vector2(screenWidth * 0.46, screenHeight * 0.94),
    Vector2(screenWidth * 0.46, screenHeight), // 화면 상단에 맞게
  ];
  // WallComponent를 추가
  final leftWall = WallComponent(points: points, position: Vector2(0, 0));
  game.add(leftWall);
}