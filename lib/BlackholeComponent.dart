import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pollette/BallComponent.dart';

class Blackholecomponent extends BodyComponent with ContactCallbacks {
  final Vector2 position;

  Blackholecomponent({required this.position});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    //블랙홀 이미지를 로드하여 표시
    final sprite = await Sprite.load('blackhole.png');

    final blackhole = SpriteComponent(
      sprite: sprite,
      size: Vector2(48, 48),
      position: position,
      anchor: Anchor.center,
    );

    add(blackhole);
  }

  @override
  Body createBody() {
    //블랙홀의 물리적 바디
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: position
    );
    final body = world.createBody(bodyDef);

    final shape = CircleShape()..radius = 24;
    final fixtureDef = FixtureDef(shape)
    ..isSensor = true;

    body.createFixture(fixtureDef);
    return body;
  }


  @override
  void beginContact(Object other, Contact contact) {
    if (other is Ballcomponent) {
      //공이 블랙홀에 닿으면 공 제거
      other.removeFromParent();
    }
    super.beginContact(other, contact);
  }
}