import 'package:flutter/material.dart';

class VentureLoadingScreen extends StatelessWidget {
  const VentureLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}