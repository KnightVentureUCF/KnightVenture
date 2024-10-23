import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const NavigationButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          foregroundColor: Colors.black,
          backgroundColor: Colors.yellow,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
