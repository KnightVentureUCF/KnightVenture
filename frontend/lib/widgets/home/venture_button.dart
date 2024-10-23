import 'package:flutter/material.dart';
import 'package:frontend/models/caches.dart' as caches;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VentureButton extends StatelessWidget {
  final List<caches.Cache> allCaches;
  final LatLng currentLocation;
  final Function(bool userLocatedAtUCF, caches.Cache cache)
      beginCacheNavigation;
  final Function(caches.Cache cache, bool cacheHasBeenFound) showCacheInfo;
  final bool userLocatedAtUCF;

  const VentureButton(
      {super.key,
      required this.allCaches,
      required this.currentLocation,
      required this.beginCacheNavigation,
      required this.userLocatedAtUCF,
      required this.showCacheInfo});

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
              showCacheInfo(closestCache, false);
            } else {
              // Show a dialog saying "All caches are completed"
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('All Caches Completed'),
                    content:
                        const Text('You have completed all available caches.'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
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
