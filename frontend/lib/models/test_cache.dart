import 'package:flutter/material.dart';

class TestCache {
  const TestCache({
    required this.name,
    required this.desc,
    required this.icon,
    required this.lat,
    required this.lng,
  });

  final String name;
  final String desc;
  final IconData icon;
  final double lat;
  final double lng;
}
