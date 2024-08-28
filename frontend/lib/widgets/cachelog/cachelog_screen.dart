import 'package:flutter/material.dart';
import 'package:frontend/widgets/styling/theme.dart';
import 'package:frontend/widgets/cachelog/cache_button.dart';
import '../../data/test_caches.dart';

class CacheLogScreen extends StatelessWidget {
  const CacheLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cache Log',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [brightGold, Color.fromARGB(255, 140, 154, 16)],
          ),
        ),
        padding: const EdgeInsets.all(50.0),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 25,
          crossAxisSpacing: 25,
          children: [
            ...testCaches.map((testCache) {
              return CacheButton(
                icon: testCache.icon,
                onPressed: () {
                  // Navigate to the cache log screen
                },
              );
            })
          ],
        ),
      ),
    );
  }
}
