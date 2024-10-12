import 'package:flutter/material.dart';
import 'package:frontend/widgets/cachelog/cachelog_screen.dart';
import 'package:frontend/widgets/profile/profile_screen.dart';
import 'package:frontend/widgets/settings/settings_screen.dart';
import 'package:frontend/widgets/styling/theme.dart';
import 'package:frontend/widgets/about/about_screen.dart';

class MainMenuScreen extends StatelessWidget {
  final String accessToken;
  final String username;

  MainMenuScreen({Key? key, required this.accessToken, required this.username})
      : super(key: key);

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
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                              accessToken: accessToken,
                              username: username,
                            )),
                  );
                },
                child: const Text('Profile'),
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
