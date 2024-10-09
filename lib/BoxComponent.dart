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
      position: Vector2.zero(),
      anchor: Anchor.center,
      paint: Paint()
        ..color = const Color(0xFFFFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    add(box);
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.kinematic,
      position: position,
    );

    final body = world.createBody(bodyDef);

    final shape = PolygonShape();
    shape.setAsBox(size.x / 2, size.y / 2, Vector2.zero(), 0);

    final fixtureDef = FixtureDef(shape)
      ..density = 5.0
      ..friction = 0.3
      ..restitution = 0.2;

    body.createFixture(fixtureDef);
    body.angularDamping = 5.0;
    body.linearDamping = 100.0;

    body.userData = this; // userData로 현재 객체를 설정

    return body;
  }

  void applyRotation(double force) {
    body.applyAngularImpulse(force);
  }
}
