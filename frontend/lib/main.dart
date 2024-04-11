import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main()async {
  await dotenv.load(fileName: ".env");
  runApp(const MaterialApp());
}

class MaterialApp extends StatelessWidget {
  const MaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

