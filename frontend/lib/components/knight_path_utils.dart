import 'package:flutter/material.dart';

// Function to create the path that the knight will follow
Path createKnightPath(Size size) {
  Path path = Path();
  // Start at the left center, end at the right center, with a high curve towards the top center
  path.moveTo(0, size.height * 0.5);
  path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.1, size.width, size.height * 0.5);
  return path;
}
