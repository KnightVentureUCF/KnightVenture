import 'package:flutter/material.dart';

class LoadingScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFC904), // The yellow background color
      body: Stack(
        children: <Widget>[
          const Positioned(
            left: 65, // Example x coordinate
            top: 770, // Example y coordinate
            width: 306,
            child: Text(
              'When she said yes to the knight, he promised to protect her for life',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            left: 173, // Example x coordinate
            top: 830, // Example y coordinate
            child: Image.asset('assets/horseback.png'),
          ),
          Positioned(
            left: 130, // Another x coordinate
            top: 640, // Another y coordinate
            child: Image.asset('assets/knight.png'),
          ),
          Positioned(
            left: 50, // Another x coordinate
            top: 50, // Another y coordinate
            child: Image.asset('assets/dotted_line.png'),
          ),
          Positioned(
            left: 100, // Another x coordinate
            top: 570, // Another y coordinate
            child: Image.asset('assets/tree.png'),
          ),
          Positioned(
            left: 280, // Another x coordinate
            top: 495, // Another y coordinate
            child: Image.asset('assets/tree.png'),
          ),
          // Positioned(
          //   left: 269, // Another x coordinate
          //   top: 391, // Another y coordinate
          //   child: Image.asset(
          //       'assets/pawprint.png'),
          // ),
          Positioned(
            left: 30, // Another x coordinate
            top: 374, // Another y coordinate
            child: Image.asset('assets/pawprint.png'),
          ),
          const Positioned(
            left: 100, // Another x coordinate
            top: 320, // Another y coordinate
            child: Text(
              'KnightVenture',
              style: TextStyle(color: Colors.black, fontSize: 42.68),
            ),
          ),
          Positioned(
            left: 70, // Another x coordinate
            top: 270, // Another y coordinate
            child: Image.asset('assets/duck.png'),
          ),
          Positioned(
            left: 209, // Another x coordinate
            top: 180, // Another y coordinate
            child: Image.asset('assets/tree.png'),
          ),
          Positioned(
            left: 300, // Another x coordinate
            top: 220, // Another y coordinate
            child: Image.asset('assets/chest.png'),
          ),
          // Repeat the Positioned widget for each item you want to place
          // Include all your items with their correct assets and positions
        ],
      ),
    );
  }
}
