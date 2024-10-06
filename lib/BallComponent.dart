 import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pollette/BlackholeComponent.dart';

//공은 블랙홀에 닿으면 사라짐
class Ballcomponent extends CircleComponent with ContactCallbacks {
  Ballcomponent({required Vector2 position, required Color color})
      : super(radius: 6, paint: Paint()
    ..color = color, position: position);

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Blackholecomponent) {
      //공이 블랙홀에 닿으면 제거
      removeFromParent();
    }
    super.beginContact(other, contact);
  }
}