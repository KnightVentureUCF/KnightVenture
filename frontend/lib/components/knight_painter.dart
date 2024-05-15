import 'package:flutter/material.dart';

// Custom painter for drawing the knight's path
class KnightPathPainter extends CustomPainter {
  final Path path;

  KnightPathPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red // Make the path visible with red color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0; // Clearly visible stroke width

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
