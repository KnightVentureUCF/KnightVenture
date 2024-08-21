import 'package:flutter/material.dart';
import 'signup_widget.dart';

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              backgroundColor: Color(0xffFFC904),
              body: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/knight.png'),
                    const SizedBox(height: 20),
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Dragon-Fire',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          // Add login logic here
                          
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpWidget(),
                          ),
                        );
                      },
                      child: const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        // Add logic for "Trouble logging in?" here
                      },
                      child: Text(
                        "Trouble logging in?",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
