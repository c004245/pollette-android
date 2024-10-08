import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
class BoxComponent extends BodyComponent {
  final Vector2 size;
  final Vector2 position;
  final double rotation;
  final bool isDynamic;

  BoxComponent({
    required this.size,
    required this.position,
    required this.rotation,
    this.isDynamic = false, // 기본값은 false로 설정
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 흰색 테두리 박스 추가
    final box = RectangleComponent(
      size: size,
      position: Vector2.zero(), // Box의 상대 위치로 변경
      anchor: Anchor.center,
      paint: Paint()
        ..color = const Color(0xFFFFFFFF) // 흰색 테두리
        ..style = PaintingStyle.stroke // 채우기 없이 테두리만 그리기
        ..strokeWidth = 2.0, // 테두리 두께
    );

    add(box);
  }

  @override
  Body createBody() {
    // 박스의 물리적 바디 정의
    final bodyDef = BodyDef(
      type: isDynamic ? BodyType.dynamic : BodyType.kinematic, // isDynamic에 따라 설정
      position: position, // BoxComponent의 절대 위치 설정
    );

    final body = world.createBody(bodyDef);

    // 박스 모양의 바디 정의
    final shape = PolygonShape();
    shape.setAsBox(size.x / 2, size.y / 2, Vector2.zero(), 0); // 중심은 (0, 0)

    // 물리적 특성 정의
    final fixtureDef = FixtureDef(shape)
      ..density = 5.0  // 박스의 질량 설정
      ..friction = 0.3  // 마찰 설정
      ..restitution = 0.2; // 반발력 설정

    body.createFixture(fixtureDef);

    // 각속도 감속 설정
    body.angularDamping = 1.0;

    return body;
  }

  // 공과 충돌 시 회전하는 효과를 주기 위한 각속도 설정
  void applyRotation(double force) {
    body.applyAngularImpulse(force); // 회전력을 적용
  }
}
