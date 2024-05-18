import 'package:flutter/material.dart';

class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4; // Ensures visibility

    var path = Path();
    // Start a bit lower than middle but more towards the left side
    path.moveTo(size.width * 0.1, size.height * 0.7);
    // First curve: slightly more stretched
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.9,
        size.width * 0.5, size.height * 0.3);
    // Second curve: also more stretched to make the S bigger
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.1,
        size.width * 0.9, size.height * 0.3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
