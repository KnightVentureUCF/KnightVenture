import 'package:flutter/material.dart';
import 'package:frontend/models/test_cache.dart';
import 'package:frontend/widgets/styling/theme.dart';
import 'package:frontend/data/deprecated_all_caches.dart';
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
    selectedCache = deprecatedAllCaches[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 232, 234, 72),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [.2, .8],
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
                allCaches: deprecatedAllCaches,
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
