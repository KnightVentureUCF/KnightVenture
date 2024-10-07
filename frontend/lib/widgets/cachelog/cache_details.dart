import 'package:flutter/material.dart';
import 'package:frontend/models/test_cache.dart';
import 'package:frontend/data/testing_newcaches.dart';

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
      padding: const EdgeInsets.only(left: 36, right: 36, top: 72),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(11.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9.0),
              child: Image.asset(
                selectedCache!.imgUrl,
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            selectedCache!.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                selectedCache!.desc,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
