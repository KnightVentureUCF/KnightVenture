import 'package:flutter/material.dart';
import 'package:frontend/widgets/home/navigation_ui.dart';
import 'package:frontend/widgets/styling/theme.dart';
import 'package:frontend/widgets/main_menu/main_menu_screen.dart';
import 'package:frontend/models/test_cache.dart';
import 'package:frontend/data/all_caches.dart';
import 'package:frontend/widgets/home/cache_popup.dart';

class HomeScreen extends StatelessWidget {
<<<<<<< HEAD
  final TestCache myCache = allCaches[0];

  HomeScreen({super.key});
=======
  final String accessToken;

  const HomeScreen({Key? key, required this.accessToken}) : super(key: key);
>>>>>>> origin

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NavigationUI(accessToken: accessToken),
          Positioned(
            top: 75,
            right: 35,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainMenuScreen()),
                );
              },
              child: const Icon(
                Icons.menu,
                size: 48,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            bottom: 45,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                CachePopup.show(context, myCache);
              },
              child: Image.asset(
                'assets/logo.png', // Replace with your actual path
                width: 160, // Set the desired width
                height: 160,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
