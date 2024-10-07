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
    this.isDynamic = false,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

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
    final bodyDef = BodyDef(
      type: isDynamic ? BodyType.dynamic : BodyType.static, // 고정 또는 동적
      position: position, // BoxComponent의 절대 위치 설정
    );

    final body = world.createBody(bodyDef);

    // 박스 모양의 바디 정의
    final shape = PolygonShape();
    shape.setAsBox(size.x / 2, size.y / 2, Vector2.zero(), 0); // 중심은 (0, 0), 회전 각도는

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.2; // 반발력 설정

    body.createFixture(fixtureDef);

    // 각속도 및 회전 설정
    body.angularDamping = pi; // 각속도 감속 설정
    body.angularVelocity = rotation; // 랜덤 회전 설정

    return body;
  }
}
