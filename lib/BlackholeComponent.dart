import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'BallComponent.dart';
class BlackholeComponent extends BodyComponent with ContactCallbacks {
  final Vector2 position;

  BlackholeComponent({required this.position});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 블랙홀 이미지를 로드하여 표시
    final sprite = await Sprite.load('blackhole.png');

    // SpriteComponent 추가하여 이미지를 화면에 렌더링
    final blackhole = SpriteComponent(
      sprite: sprite,
      position: Vector2(0, 0)
      // size: Vector2(48, 48),  // 이미지 크기
      // position: position - Vector2(24, 24),  // 중앙을 기준으로 위치 맞추기
      // anchor: Anchor.center,  // 중앙 기준 배치
    );

    add(blackhole);  // 이미지를 BodyComponent에 추가
  }

  @override
  Body createBody() {
    // 블랙홀의 물리적 바디 설정 (물리적 경계만 존재)
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: position,
    );

    final body = world.createBody(bodyDef);

    // CircleShape으로 물리적 경계 설정 (렌더링되지 않음)
    final shape = CircleShape()..radius = 24;  // 반지름은 Sprite 크기에 맞게 설정

    final fixtureDef = FixtureDef(shape)
      ..isSensor = true; // 센서로 설정하여 충돌만 감지

    body.createFixture(fixtureDef);

    return body;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Ballcomponent) {
      // 공이 블랙홀에 닿으면 제거
      other.removeFromParent();
    }
    super.beginContact(other, contact);
  }
}
