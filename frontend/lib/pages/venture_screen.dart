import "package:flutter/material.dart";
import "package:frontend/components/navigation_ui.dart";

class VentureScreen extends StatelessWidget {
  const VentureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // useMaterial3: true,
        primaryColor: const Color.fromARGB(255, 255, 201, 4),
      ),
      home: const Scaffold(
        body: NavigationUI(),
      ),
    );
  }
}
