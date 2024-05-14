import "package:flutter/material.dart";
import "package:frontend/components/navigation_ui.dart";

class VentureScreen extends StatelessWidget {
  const VentureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color.fromARGB(255, 255, 201, 4),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          elevation: 2,
        ),
        body: const NavigationUI(),
      ),
    );
  }
}
