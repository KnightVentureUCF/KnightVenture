import 'package:flutter/material.dart';
import 'package:frontend/models/test_cache.dart';

class CacheDetails extends StatelessWidget {
  const CacheDetails({super.key, required this.selectedCache});

  final TestCache? selectedCache;

  @override
  Widget build(BuildContext context) {
    if (selectedCache == null) {
      return const Center(
        child: Text(
          'No cache selected',
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Image.asset(selectedCache!.imgUrl),
          Text(
            selectedCache!.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            selectedCache!.desc,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
