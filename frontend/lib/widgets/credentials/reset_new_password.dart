//TODO: test again

import 'package:flutter/material.dart';
import 'package:frontend/utils/pathbuilder.dart';
import 'package:frontend/widgets/credentials/credentials_screen.dart';
import 'package:frontend/widgets/credentials/login_screen.dart';
import 'package:frontend/widgets/credentials/signup_screen.dart';
import 'package:frontend/widgets/styling/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetNewPassword extends StatefulWidget {
  final String username;

  ResetNewPassword({required this.username});

  @override
  _ResetNewPassword createState() => _ResetNewPassword();
}

class _ResetNewPassword extends State<ResetNewPassword> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> newPasswordReset() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String username = widget.username;
    final String code = _codeController.text.trim();
    final String newPassword = _newPasswordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match';
        _isLoading = false;
      });
      return;
    }

    // Replace with your actual API endpoint
    final String apiUrl = buildPath("api/confirm_password_reset");

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {'username': username, 'code': code, 'newPassword': newPassword}),
      );

      if (response.statusCode == 200) {
        // Handle success (e.g., navigate to another screen)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset successfully.')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CredentialsScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to reset password. Please try again.';
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
        title: const Text('Forgot password'),
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
            const SizedBox(height: 50),
            const Text(
              'Enter Verification Code',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.black, width: 3.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 3),
                ),
                hintText: 'Enter Verification Code',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter New Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.black, width: 3.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 3),
                ),
                hintText: 'At least 8 characters',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Confirm New Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.black, width: 3.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 3),
                ),
                hintText: 'Has to match with the above',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : newPasswordReset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Reset Password',
                      style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CredentialsScreen()),
                ); // Go back to the sign-in page
              },
              child: Text('Back to sign in',
                  style: TextStyle(color: Colors.black)),
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('You don\'t have an account?',
                    style: TextStyle(color: Colors.black)),
              ],
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpWidget()),
                );
              },
              child: Text('Sign up', style: TextStyle(color: Colors.black)),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
