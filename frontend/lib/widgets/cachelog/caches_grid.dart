import 'package:flutter/material.dart';
import 'package:frontend/models/test_cache.dart';

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
            padding:
                const EdgeInsets.only(left: 18, right: 18, top: 36, bottom: 72),
            child: Image.asset(allCaches[index].icon),
          ),
        );
      },
    );
  }
}
