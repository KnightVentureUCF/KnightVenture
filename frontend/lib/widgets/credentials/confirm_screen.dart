import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/styling/theme.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';

class ConfirmWidget extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final String? _email; // Store email as a private variable

  ConfirmWidget({super.key, String? username, String? email}) : _email = email {
    if (username != null) {
      _usernameController.text = username;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brightGold,
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Verification',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter Username',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter username',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter Verification Code',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter verification code',
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Resend logic here
              },
              child: const Text(
                "If you didn't receive a code, Resend",
                style: TextStyle(
                  color: Colors.red,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () async {
                  await _confirmRegistration(context);
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.facebook),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.apple),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Navigate to login screen
                Navigator.pop(context);
              },
              child: const Text(
                "Do you have an account?",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle confirmation
  Future<void> _confirmRegistration(BuildContext context) async {
    final String username = _usernameController.text;
    final String confirmationCode = _codeController.text;

    if (username.isEmpty || confirmationCode.isEmpty) {
      // Handle empty fields
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Username and verification code are required."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    try {
      const String apiUrl = "http://localhost:3000/api/confirm_registration";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'confirmationCode': confirmationCode,
          'email': _email!,
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful confirmation by navigating to LoginWidget
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginWidget()),
          (route) => false, // Remove all previous routes
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account successfully confirmed. Please log in.'),
          ),
        );
      } else {
        throw Exception('Failed to confirm registration.');
      }
    } catch (e) {
      // Handle errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text("Confirmation failed: ${e.toString()}"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }
}
