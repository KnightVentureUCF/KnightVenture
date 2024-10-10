import 'package:flutter/material.dart';
import 'package:frontend/widgets/home/navigation_ui.dart';
import 'package:frontend/widgets/styling/theme.dart';
import 'package:frontend/widgets/main_menu/main_menu_screen.dart';
import 'package:frontend/models/test_cache.dart';

class HomeScreen extends StatelessWidget {
  final String accessToken;
  final String username;

  const HomeScreen(
      {Key? key, required this.accessToken, required this.username})
      : super(key: key);

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
                      builder: (context) =>
                          MainMenuScreen(accessToken: accessToken, username: username)),
                );
              },
              child: const Icon(
                Icons.menu,
                size: 48,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
