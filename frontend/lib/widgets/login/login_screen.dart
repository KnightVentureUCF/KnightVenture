import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'login_widget.dart';
import 'signup_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFC904),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Image.asset(
                  'assets/knight_icon.png',
                  width: 200,
                  height: 200,
                )),
            const Text(
              'KnightVenture',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Knight cannot be made to fear. Let’s the hunt begin!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              width: 305,
              height: 61,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginWidget()),
                ),
                child: Text('Login'),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 305,
              height: 61,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpWidget()),
                ),
                child: Text('Sign Up', style: TextStyle(color: Colors.black)),
              ),
            ),
            const Image(
              image: AssetImage('assets/horseback.png'),
              width: 100,
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
