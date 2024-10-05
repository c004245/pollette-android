 import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/contact_callbacks.dart';

class Ballcomponent extends CircleComponent with ContactCallbacks {
  Ballcomponent({required Vector2 position, required Color color})
  : super(radius: 6, paint: Paint()..color = color, position: position);

  @override
    
