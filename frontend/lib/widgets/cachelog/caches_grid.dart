import 'package:flutter/material.dart';
import 'package:frontend/models/test_cache.dart';
import 'package:frontend/data/all_caches.dart';

class CachesGrid extends StatelessWidget {
  const CachesGrid(
      {super.key, required this.allCaches, required this.onCacheSelected});

  final List<TestCache> allCaches;
  final void Function(TestCache) onCacheSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: allCaches.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onCacheSelected(allCaches[index]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(allCaches[index].icon),
          ),
        );
      },
    );
  }
}
