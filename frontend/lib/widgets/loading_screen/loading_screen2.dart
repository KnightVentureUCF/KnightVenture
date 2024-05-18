import 'package:flutter/material.dart';
import 'package:frontend/widgets/login/login_screen.dart';

class LoadingScreenWidget extends StatefulWidget {
  @override
  _LoadingScreenWidgetState createState() => _LoadingScreenWidgetState();
}

class _LoadingScreenWidgetState extends State<LoadingScreenWidget> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    await Future.delayed(Duration(seconds: 3)); // Wait for 3 seconds
    if (!mounted) return; // Check if the widget is still in the tree
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginScreen()), // Navigate to the LoginScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFC904), // The yellow background color
      body: Stack(
        children: <Widget>[
          // Positioned widgets for images and texts here...
          const Positioned(
            left: 65,
            top: 770,
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
            left: 190,
            top: 830,
            child: Image.asset('assets/horseback.png'),
          ),
          Positioned(
            left: 130,
            top: 640,
            child: Image.asset('assets/knight.png'),
          ),
          Positioned(
            left: 50,
            top: 50,
            child: Image.asset('assets/dotted_line.png'),
          ),
          Positioned(
            left: 100,
            top: 570,
            child: Image.asset('assets/tree.png'),
          ),
          Positioned(
            left: 280,
            top: 495,
            child: Image.asset('assets/tree.png'),
          ),
          Positioned(
            left: 30,
            top: 374,
            child: Image.asset('assets/pawprint.png'),
          ),
          const Positioned(
            left: 100,
            top: 320,
            child: Text(
              'KnightVenture',
              style: TextStyle(color: Colors.black, fontSize: 42.68),
            ),
          ),
          Positioned(
            left: 70,
            top: 270,
            child: Image.asset('assets/duck.png'),
          ),
          Positioned(
            left: 209,
            top: 180,
            child: Image.asset('assets/tree.png'),
          ),
          Positioned(
            left: 300,
            top: 220,
            child: Image.asset('assets/chest.png'),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
