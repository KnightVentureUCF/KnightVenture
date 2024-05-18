import 'package:flutter/material.dart';

class LoadingScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffFFC904), // The yellow background color
      child: Center(
        // Centering the image
        child: Image.asset(
          'assets/dotted_line.png', // Path to the image
        ),
      ),
    );
  }
}
