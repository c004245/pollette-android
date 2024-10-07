import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'dart:math';

class SpinnerComponent extends BodyComponent {
  final Vector2 size;
  final Vector2 position;
  final double rotationSpeed; // 회전 속도

  SpinnerComponent({
    required this.size,
    required this.position,
    required this.rotationSpeed,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 직사각형을 렌더링하기 위한 RectangleComponent 생성
    final spinner = RectangleComponent(
      size: size,
      position: position,
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0x00000000), // 투명하게 설정
    );

    add(spinner); // 회전하는 스피너 추가
  }

  @override
  Body createBody() {
    // 물리적 바디 정의
    final bodyDef = BodyDef(
      type: BodyType.kinematic, // 움직이는 바디로 설정
      position: position,
    );

    final body = world.createBody(bodyDef);

    // 직사각형 모양의 바디 설정
    final shape = PolygonShape();
    shape.setAsBox(size.x / 2, size.y / 2, Vector2.zero(), 0); // 중심은 (0, 0), 회전 각도는 0

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.8;

    body.createFixture(fixtureDef);

    // 각속도 감속을 없앰 (지속적인 회전)
    body.angularDamping = 0;

    // 초기 각속도 설정 (회전 시작)
    body.angularVelocity = rotationSpeed;

    return body;
  }

  @override
  void update(double dt) {
    // 회전 속도를 유지하기 위해 angularVelocity 계속 적용
    body.angularVelocity = rotationSpeed;
    super.update(dt);
  }
}

void addSpinner(Forge2DGame game, double screenWidth, double screenHeight, double rotationSpeed) {
  // Spinner의 크기 및 위치 설정
  final spinnerSize = Vector2(screenWidth / 2.5, 10);
  final spinnerPosition = Vector2(screenWidth / 2, screenHeight - 24); // 핸드폰 하단 중앙

  // SpinnerComponent를 게임에 추가
  final spinner = SpinnerComponent(
    size: spinnerSize,
    position: spinnerPosition,
    rotationSpeed: rotationSpeed,
  );

  game.add(spinner);
}
