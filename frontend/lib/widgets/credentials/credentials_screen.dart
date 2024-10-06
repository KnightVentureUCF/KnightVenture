import 'package:flutter/material.dart';
import 'package:frontend/widgets/styling/theme.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class CredentialsScreen extends StatefulWidget {
  const CredentialsScreen({super.key});

  @override
  _CredentialsScreenState createState() => _CredentialsScreenState();
}

class _CredentialsScreenState extends State<CredentialsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brightGold,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
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
                        "Knights cannot be made to fear. Let the hunt begin!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
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
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 305,
                      height: 61,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                        ),
                        child: const Text('Sign Up',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 20),
            //   child: Image.asset(
            //     'assets/horseback.png',
            //     width: 100,
            //     height: 100,
            //   ),
            // ),
            Positioned(
              left:
                  190, // You may need to adjust this based on your layout requirements
              bottom:
                  20, // This positions the widget 20 pixels from the bottom of the Stack
              child: Image.asset(
                'assets/horseback.png',
                width: 100,
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
