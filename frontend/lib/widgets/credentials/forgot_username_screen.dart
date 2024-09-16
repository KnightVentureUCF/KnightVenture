import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/widgets/credentials/credentials_screen.dart';
import 'package:frontend/widgets/credentials/login_screen.dart';
import 'package:frontend/widgets/credentials/signup_screen.dart';
import 'package:frontend/widgets/styling/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotUsernameWidget extends StatefulWidget {
  @override
  _ForgotUsernameWidgetState createState() => _ForgotUsernameWidgetState();
}

class _ForgotUsernameWidgetState extends State<ForgotUsernameWidget> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _sendForgotUsernameRequest() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String username = _usernameController.text.trim();

    // Replace with your actual API endpoint
    String apiUrl = 'http://localhost:3000/api/forgot_uswername';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username}),
      );

      if (response.statusCode == 200) {
        // Handle success (e.g., navigate to another screen)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Username reset request sent successfully.')),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                     LoginScreen() // Replace with your next screen
                ));
      } else {
        setState(() {
          _errorMessage = 'Failed to send reset request. Please try again.';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brightGold,
      appBar: AppBar(
        title: const Text('Forgot Username'),
        backgroundColor: brightGold,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/knight.png',
              width: 179,
              height: 193,
            ),
            const SizedBox(height: 10),
            const Text(
              'Enter Your Email Address',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 3.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 3),
                ),
                hintText: 'jimmy2001@gmail.com',
              ),
            ),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendForgotUsernameRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Send', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  LoginScreen()),
                ); // Go back to the sign-in page
              },
              child: const Text('Back to sign in',
                  style: TextStyle(color: Colors.black)),
            ),
            const Spacer(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // IconButton(
                //   icon: Icon(Icons.facebook, color: Colors.black),
                //   onPressed: () {},
                // ),
                // IconButton(
                //   icon: Icon(Icons.g_translate, color: Colors.black),
                //   onPressed: () {},
                // ),
                // IconButton(
                //   icon: Icon(Icons.apple, color: Colors.black),
                //   onPressed: () {},
                // ),
                Text('You dont\'t have an account?',
                    style: TextStyle(color: Colors.black)),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpWidget()),
                );
              },
              child:
                  const Text('Sign up', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
