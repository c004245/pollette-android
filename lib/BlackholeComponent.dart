import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pollette/BallComponent.dart';

class Blackholecomponent extends CircleComponent with ContactCallbacks {
  Blackholecomponent(Vector2 position): super(radius: 30, paint: Paint()..color = Colors.black, position: position);

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Ballcomponent) {
      //공이 블랙홀에 닿으면 공 제거
      other.removeFromParent();
    }
    super.beginContact(other, contact);
  }
}