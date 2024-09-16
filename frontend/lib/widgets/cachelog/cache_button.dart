import 'package:flutter/material.dart';

class CacheButton extends StatelessWidget {
  const CacheButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        child: Icon(
          icon,
          size: 40,
        ),
      ),
    );
  }
}
