import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          'About information goes here',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
