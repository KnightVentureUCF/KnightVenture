import 'package:flutter/material.dart';
// import 'package:frontend/models/test_cache.dart';
import 'package:frontend/models/caches.dart' as caches;

class CachesGrid extends StatelessWidget {
  const CachesGrid(
      {super.key, required this.allCaches, required this.onCacheSelected});

  final List<caches.Cache> allCaches;
  final void Function(caches.Cache) onCacheSelected;

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
            child: Image.network(allCaches[index].iconUrl ?? ''),
          ),
        );
      },
    );
  }
}
