import 'package:flutter/material.dart';
import 'package:frontend/models/caches.dart' as caches;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VentureButton extends StatelessWidget {
  final List<caches.Cache> allCaches;
  final LatLng currentLocation;
  final Function(bool userLocatedAtUCF, caches.Cache cache)
      beginCacheNavigation;
  final bool userLocatedAtUCF;

  const VentureButton(
      {super.key,
      required this.allCaches,
      required this.currentLocation,
      required this.beginCacheNavigation,
      required this.userLocatedAtUCF});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: GestureDetector(
          onTap: () {
            if (allCaches.isNotEmpty) {
              caches.Cache closestCache = allCaches.reduce((a, b) {
                double distanceA = Geolocator.distanceBetween(
                    currentLocation.latitude,
                    currentLocation.longitude,
                    a.lat,
                    a.lng);
                double distanceB = Geolocator.distanceBetween(
                    currentLocation.latitude,
                    currentLocation.longitude,
                    b.lat,
                    b.lng);
                return distanceA < distanceB ? a : b;
              });
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors
                    .transparent, // This makes the entire sheet transparent
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
                                    closestCache.name,
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
                              closestCache.desc ?? 'No description available',
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
                              onPressed: () {
                                beginCacheNavigation(
                                    userLocatedAtUCF, closestCache);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.yellow, // Text color
                              ),
                              child: const Text('Start!',
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
            }
          },
          child: Image.asset(
            "assets/logo.png",
            width: 160,
            height: 160,
          ),
        ),
      ),
    );
  }
}
