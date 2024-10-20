import 'package:flutter/cupertino.dart';

class BallPainter extends CustomPainter {
  final Color color;

  BallPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2, paint);  // 원 그리기
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
