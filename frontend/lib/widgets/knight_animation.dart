import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../components/knight_painter.dart';
import '../components/knight_path_utils.dart';

class KnightAnimation extends StatefulWidget {
  @override
  _KnightAnimationState createState() => _KnightAnimationState();
}

class _KnightAnimationState extends State<KnightAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    Path path = createKnightPath(MediaQuery.of(context).size);
    PathMetric pathMetric = path.computeMetrics().first;
    Tangent? knightPos =
        pathMetric.getTangentForOffset(pathMetric.length * _animation.value);

    // Debugging prints to check path and knight position
    print('Screen size: ${MediaQuery.of(context).size}');
    print('Path size: ${path.getBounds()}');
    print('Knight position: ${knightPos?.position}');
    print('Angle: ${knightPos?.angle}');

    return CustomPaint(
      painter: KnightPathPainter(path),
      child: Positioned(
        left: knightPos!.position.dx - 24, // Center the icon on the path
        top: knightPos.position.dy - 24,
        child: Transform.rotate(
          angle: knightPos.angle +
              math.pi / 2, // Rotate icon to align with the path direction
          child: Icon(Icons.emoji_people,
              size: 48.0), // Larger icon for better visibility
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
