import 'package:flutter/material.dart';
import 'package:frontend/widgets/credentials/credentials_screen.dart';
import 'package:frontend/widgets/credentials/loading_screen.dart';
import 'package:frontend/widgets/cachelog/cachelog_screen.dart';
import 'package:frontend/widgets/credentials/login_screen.dart';

void main() {
  runApp(MaterialApp(
    home: LoginScreen(), // Using the new LoadingScreenWidget
  ));
}
