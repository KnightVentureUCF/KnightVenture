import 'package:flutter/material.dart';
import 'package:frontend/models/login_response.dart';
import 'package:frontend/widgets/credentials/forgot_password_screen.dart';
import 'package:frontend/widgets/dataprovider/data_provider.dart';
import 'dart:convert';
import 'package:frontend/widgets/home/home_screen.dart';
import 'package:frontend/utils/pathbuilder.dart';
import 'package:frontend/widgets/styling/theme.dart';
import 'package:http/http.dart' as http;
import 'signup_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  // Define text controllers to get the username and password
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              backgroundColor: brightGold,
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
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
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
                          // First, perform the login and wait for the result
                          final loginResponse = await _login(context);

                          // Navigate to HomeScreen only if the login was successful
                          if (loginResponse != null &&
                              loginResponse.accessToken.isNotEmpty) {
                            // Data provider for initial API calls
                            final dataProvider = Provider.of<DataProvider>(
                                context,
                                listen: false);
                            await dataProvider.loadUserData(loginResponse.accessToken,
                                _usernameController.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                    accessToken: loginResponse.accessToken,
                                    username: _usernameController
                                        .text), // Pass the accessToken
                              ),
                            );
                          }
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
                            builder: (context) => SignUpScreen(),
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
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text(
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

// Function to handle login
  Future<LoginResponse?> _login(BuildContext context) async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      // Handle empty fields (e.g., show a dialog)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Username and Password cannot be empty."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return null;
    }

    try {
      final String apiUrl = buildPath("api/login");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final loginResponse =
            LoginResponse.fromJson(data['AuthenticationResult']);
        return loginResponse;
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        final String errorMessage = errorData['message'] ?? 'Failed to log in.';

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text("Login failed: ${e.toString()}"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
    return null;
  }
}
