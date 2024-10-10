 import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pollette/BlackholeComponent.dart';
 // 공은 블랙홀에 닿으면 사라짐
 class Ballcomponent extends BodyComponent with ContactCallbacks {
   final Vector2 position;
   final Color color;

   Ballcomponent({required this.position, required this.color});

   @override
   Body createBody() {
     final shape = CircleShape()..radius = 6;
     final bodyDef = BodyDef(
       type: BodyType.dynamic,
       position: position,
     );

     final fixtureDef = FixtureDef(shape)
       ..restitution = 0.8
       ..density = 1.0;

     final body = world.createBody(bodyDef);
     body.createFixture(fixtureDef);

     body.userData = this; // userData로 현재 객체를 설정

     return body;
   }

   @override
   void beginContact(Object other, Contact contact) {
     if (other is BlackholeComponent) {
       print("delete call");
       // 공이 블랙홀에 닿으면 제거
       removeFromParent();
     }
     super.beginContact(other, contact);
   }

   @override
   void render(Canvas canvas) {
     // 공을 그리는 로직 (색상 적용)
     final paint = Paint()..color = color;
     canvas.drawCircle(Offset.zero, 6, paint);  // 반지름 6으로 원 그리기
   }
 }
