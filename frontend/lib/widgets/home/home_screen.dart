import 'package:flutter/material.dart';
import 'package:frontend/widgets/dataprovider/data_provider.dart';
import 'package:frontend/widgets/home/loading_screen.dart';
import 'package:frontend/widgets/home/navigation_ui.dart';
import 'package:frontend/widgets/main_menu/main_menu_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final String accessToken;
  final String username;

  const HomeScreen(
      {super.key, required this.accessToken, required this.username});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    if (dataProvider.isLoading) {
      return const VentureLoadingScreen();
    }
    return Scaffold(
      body: Stack(
        children: [
          NavigationUI(accessToken: accessToken, username: username),
          Positioned(
            top: 75,
            right: 35,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainMenuScreen(
                          accessToken: accessToken, username: username)),
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
