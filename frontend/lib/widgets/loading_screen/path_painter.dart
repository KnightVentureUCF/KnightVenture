import 'package:flutter/material.dart';

class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    var path = Path();
    // Define the path according to your specific design
    path.moveTo(size.width / 2, size.height / 2);
    path.addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: 100));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
