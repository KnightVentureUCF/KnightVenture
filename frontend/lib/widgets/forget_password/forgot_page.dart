import 'package:flutter/material.dart';
import 'package:frontend/widgets/login/login_widget.dart';
import 'package:frontend/widgets/login/signup_widget.dart';

class ForgotSomethingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFC904),
      appBar: AppBar(
        title: Text('Forgot Something ?'),
        backgroundColor: Color(0xffFFC904),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Image.asset('assets/knight.png'),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      // Add logic here
                    },
                    child: const Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      // Add logic here
                    },
                    child: const Text(
                      'Retrieve Username',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginWidget(),
                      ),
                    );
                  },
                  child: const Text(
                    "Remember your account? Login here.",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
