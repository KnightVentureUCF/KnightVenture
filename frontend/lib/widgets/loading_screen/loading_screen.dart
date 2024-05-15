import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'path_painter.dart'; // Import the custom painter

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller)
      ..addListener(() {
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
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Stack(
        children: [
          Positioned(
            left: (MediaQuery.of(context).size.width / 2 - 50) +
                100 * math.cos(_animation.value),
            top: (MediaQuery.of(context).size.height / 2 - 50) +
                100 * math.sin(_animation.value),
            child: Image.asset('assets/knight_horse.png', width: 100),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: PathPainter(),
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
