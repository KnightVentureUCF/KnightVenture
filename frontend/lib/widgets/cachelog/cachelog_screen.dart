import 'package:flutter/material.dart';
import 'package:frontend/models/test_cache.dart';
import 'package:frontend/widgets/styling/theme.dart';
import 'package:frontend/data/all_caches.dart';
import 'cache_details.dart';
import 'caches_grid.dart';

class CacheLogScreen extends StatefulWidget {
  const CacheLogScreen({super.key});

  @override
  _CacheLogScreenState createState() => _CacheLogScreenState();
}

class _CacheLogScreenState extends State<CacheLogScreen> {
  TestCache? selectedCache;

  @override
  void initState() {
    super.initState();
    selectedCache = allCaches[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [brightGold, Color.fromARGB(255, 232, 234, 72)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: CacheDetails(
                selectedCache: selectedCache,
              ),
            ),
            Expanded(
              flex: 1,
              child: CachesGrid(
                allCaches: allCaches,
                onCacheSelected: (cache) {
                  setState(() {
                    selectedCache = cache;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
