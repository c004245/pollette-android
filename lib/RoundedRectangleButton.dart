import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class RoundedRectangleButton extends PositionComponent {
  final double width;
  final double height;
  final double radius;
  final Color color;

  RoundedRectangleButton({
    required this.width,
    required this.height,
    required this.radius,
    required this.color,
    Vector2? position,
  }) : super(
    size: Vector2(width, height),
    position: position ?? Vector2.zero(),
  );

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    final rect = Rect.fromLTWH(0, 0, width, height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.drawRRect(rRect, paint);
  }
}
