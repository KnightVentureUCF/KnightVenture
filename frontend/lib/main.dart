import 'package:flutter/material.dart';
import 'package:frontend/widgets/credentials/credentials_screen.dart';
import 'package:frontend/widgets/credentials/loading_screen.dart';

void main() {
  runApp(const MaterialApp(
    home: LoginScreen(), // Using the new LoadingScreenWidget
  ));
}
