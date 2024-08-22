import 'package:flutter/material.dart';
import 'package:frontend/widgets/home/navigation_ui.dart';
import 'package:frontend/widgets/styling/theme.dart';
import 'package:frontend/widgets/main_menu/main_menu_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const NavigationUI(),
          Positioned(
            top: 50,
            left: 35,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainMenuScreen()),
                );
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brightGold,
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
