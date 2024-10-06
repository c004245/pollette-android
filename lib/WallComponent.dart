import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class WallComponent extends BodyComponent {
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
    ..restitution = 0.8;

    body.createFixture(fixtureDef);

    return body;
  }
}

void addRightGround(Forge2DGame game) {
  final screenWidth = game.size.x;
  final screenHeight = game.size.y;

  //point
  final points = [
    Vector2(0, screenHeight),
    Vector2(0, screenHeight * 0.2),
    Vector2(screenWidth * -0.2, screenHeight * 0.1),
    Vector2(screenWidth * -0.35, screenHeight * 0.08),
    Vector2(screenWidth * -0.46, screenHeight * 0.06),
    Vector2(screenWidth * -0.46, -screenHeight * 0.5),
  ];

  //WallComponent
  final rightWall = WallComponent(points: points, position: Vector2(screenWidth, 0));
  game.add(rightWall);
}


void addLeftGround(Forge2DGame game) {
  final screenWidth = game.size.x;
  final screenHeight = game.size.y;

  // 점들 정의 (CGPoints에 해당하는 좌표)
  final points = [
    Vector2(0, screenHeight),
    Vector2(0, screenHeight * 0.2),
    Vector2(screenWidth * 0.2, screenHeight * 0.1),
    Vector2(screenWidth * 0.35, screenHeight * 0.08),
    Vector2(screenWidth * 0.46, screenHeight * 0.06),
    Vector2(screenWidth * 0.46, -screenHeight * 0.5),
  ];

  // WallComponent를 추가
  final leftWall = WallComponent(
    points: points,
    position: Vector2(0, 0), // 왼쪽 위치 설정
  );
  game.add(leftWall);
}