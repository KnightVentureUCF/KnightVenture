import 'package:flutter/material.dart';
import 'package:frontend/widgets/cachelog/cachelog_screen.dart';
import 'package:frontend/widgets/settings/settings_screen.dart';
import 'package:frontend/widgets/styling/theme.dart';
import 'package:frontend/widgets/about/about_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brightGold,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 305,
              height: 61,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CacheLogScreen()),
                  );
                },
                child: const Text('Caches'),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 305,
              height: 61,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
                child: const Text('Settings'),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 305,
              height: 61,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                },
                child: const Text('About'),
              ),
            ),
            SizedBox()
          ],
        ),
      ),
    );
  }
}
