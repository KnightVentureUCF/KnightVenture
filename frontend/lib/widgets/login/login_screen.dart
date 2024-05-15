import 'package:flutter/material.dart';
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
      backgroundColor: Colors.yellow[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Icon(
                Icons.shield,
                size: 100.0,
                color: Colors.black,
              ),
            ),
            Text(
              'KnightVenture',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Knight cannot be made to fear. Let’s the hunt begin!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
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
            SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.black),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpWidget()),
              ),
              child: Text('Sign Up', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
