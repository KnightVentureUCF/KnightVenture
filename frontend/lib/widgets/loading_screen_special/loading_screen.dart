import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'path_painter.dart'; // Import the custom painter

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Path _path;
  late ui.PathMetric _pathMetric;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // Define the S-shaped path
    _path = Path();
    _path.moveTo(0, 1290 * 0.7); // Adjusted starting point
    _path.quadraticBezierTo(2796 * 0.3, 1290 * 0.9, 2796 * 0.5, 1290 * 0.3);
    _path.quadraticBezierTo(2796 * 0.7, 1290 * 0.1, 2796 * 0.9, 1290 * 0.3);
    _pathMetric = _path.computeMetrics().first;

    _controller.addListener(() {
      setState(() {}); // Force build when animation value changes
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final position = _pathMetric
            .getTangentForOffset(_pathMetric.length * _controller.value)
            ?.position ??
        Offset.zero;

    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Stack(
        children: [
          Positioned(
            left: position.dx - 50, // Center the image at the path position
            top: position.dy - 50,
            child: Image.asset('assets/knight_horse.png', width: 100),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: PathPainter(), // Ensure this draws the S-shaped path
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "When she said yes to the knight, he promised to protect her for life",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
