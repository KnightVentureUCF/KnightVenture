import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:frontend/pages/venture_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  runApp(const MaterialApp(
    home: VentureScreen(),
  ));
}
