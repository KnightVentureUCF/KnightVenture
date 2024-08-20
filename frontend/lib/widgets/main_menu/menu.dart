import 'package:flutter/material.dart';
import 'package:frontend/widgets/cachelog/cachelog.dart';
import 'package:frontend/widgets/settings/settings.dart';
import 'package:frontend/widgets/styling/theme.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({Key? key});

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
                    MaterialPageRoute(builder: (context) => CacheLog()),
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
                    MaterialPageRoute(builder: (context) => SettingsPage()),
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
                onPressed: () {},
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
