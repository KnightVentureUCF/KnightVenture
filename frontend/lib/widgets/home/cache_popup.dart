import 'package:flutter/material.dart';

import 'package:frontend/models/caches.dart';

class CachePopup extends StatelessWidget {
  final Cache cache;

  const CachePopup({super.key, required this.cache});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor:
            Colors.transparent, // This makes the entire sheet transparent
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.7,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black
                    .withOpacity(0.8), // Black with slight transparency
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/default_cache_icon.png",
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Center(
                          child: Text(
                            cache.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      cache.desc ?? 'No description available',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Spacer(), // Add a spacer to push the button to the bottom
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.yellow, // Text color
                      ),
                      child: const Text('Venture!',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  // Add more widgets here as needed
                ],
              ),
            ),
          );
        },
      );
    });

    return Container(); // Return an empty container as the widget needs to return something
  }
}
