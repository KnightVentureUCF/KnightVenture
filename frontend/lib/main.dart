import 'package:flutter/material.dart';
import 'package:frontend/widgets/dataprovider/data_provider.dart';
import 'package:provider/provider.dart'; // Add this import
import 'package:frontend/widgets/credentials/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: MyApp(),
    ),
  );
}

// Define your main app structure
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}
