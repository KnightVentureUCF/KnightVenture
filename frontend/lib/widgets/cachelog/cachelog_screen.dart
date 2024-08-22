import 'package:flutter/material.dart';

class CacheLogScreen extends StatelessWidget {
  const CacheLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cache Log'),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          'Caches to go here',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
