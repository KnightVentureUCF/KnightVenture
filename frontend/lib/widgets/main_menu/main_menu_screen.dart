import 'package:flutter/material.dart';
import 'package:frontend/models/caches.dart' as caches;

import 'package:frontend/widgets/cachelog/cachelog_screen.dart';
import 'package:frontend/widgets/leaderboard/leaderboard_screen.dart';
import 'package:frontend/widgets/profile/profile_screen.dart';
import 'package:frontend/widgets/styling/theme.dart';
import 'package:frontend/widgets/about/about_screen.dart';

class MainMenuScreen extends StatelessWidget {
  final String accessToken;
  final String username;
  final List<caches.Cache> allCaches;

  const MainMenuScreen({
    super.key,
    required this.accessToken,
    required this.username,
    required this.allCaches,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brightGold,
      appBar: AppBar(
        backgroundColor: brightGold,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
                    MaterialPageRoute(
                        builder: (context) => CacheLogScreen(
                              allCaches: allCaches,
                            )),
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
                    MaterialPageRoute(
                        builder: (context) => LeaderboardScreen()),
                  );
                },
                child: const Text('Leaderboard'),
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
          ],
        ),
      ),
    );
  }
}
