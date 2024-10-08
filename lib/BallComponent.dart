 import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pollette/BlackholeComponent.dart';

 import 'dart:ui';
 import 'package:flame_forge2d/contact_callbacks.dart';

 // 공은 블랙홀에 닿으면 사라짐
 class Ballcomponent extends BodyComponent with ContactCallbacks {
   final Vector2 position;
   final Color color;

   Ballcomponent({required this.position, required this.color});

   @override
   Body createBody() {
     // 공의 물리적 바디 설정
     final shape = CircleShape()..radius = 6;  // 반지름 6으로 원형 바디 설정
     final bodyDef = BodyDef(
       type: BodyType.dynamic,  // 중력에 반응하도록 동적 바디 설정
       position: position,
     );

     // 공의 물리적 특성 (반발 계수, 밀도 등)
     final fixtureDef = FixtureDef(shape)
       ..restitution = 0.8  // 튕김 효과
       ..density = 1.0;     // 공의 밀도

     final body = world.createBody(bodyDef)
       ..createFixture(fixtureDef);

     return body;
   }

   @override
   void beginContact(Object other, Contact contact) {
     if (other is BlackholeComponent) {
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
