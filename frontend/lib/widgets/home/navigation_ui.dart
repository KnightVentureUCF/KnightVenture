import "dart:ffi";

import "package:flutter/material.dart";
import "package:frontend/widgets/home/cache_popup.dart";
import "package:frontend/widgets/home/loading_screen.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import 'package:frontend/widgets/main_menu/main_menu_screen.dart';
import 'package:frontend/data/all_caches.dart';
import "package:geolocator/geolocator.dart";
import "package:frontend/models/caches.dart" as caches;
import "package:frontend/constants.dart" show initialMapZoomOnVentureScreen;

class NavigationUI extends StatefulWidget {
  final String accessToken; // Add accessToken as a final field

  const NavigationUI({Key? key, required this.accessToken})
      : super(key: key); // Add accessToken as a named required parameter

  @override
  State<NavigationUI> createState() => _NavigationUIState();
}

class _NavigationUIState extends State<NavigationUI> {
  late GoogleMapController _mapController;
  late LatLng _currentLocation;
  LatLng? _destination;
  bool _cacheLocationsLoaded = false;
  bool _userLocationLoaded = false;
  final Map<String, Marker> _cacheMarkers = {};
  List<caches.Cache> _allCaches = [];

  // Define UCF location data
  bool _userLocatedAtUCF = false;
  static const LatLng ucfCampusCenter =
      LatLng(28.60197, -81.20051); // Example: UCF Main Campus
  static const LatLng ucfNECorner = LatLng(28.6060, -81.1940);
  static const LatLng ucfSWCorner = LatLng(28.5900, -81.2130);
  static const double ucfCampusRadius = 2000; // Radius in meters (e.g., 2km)

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadCacheMarkers();
  }

  void _loadCacheMarkers() async {
    final cacheLocations = await caches.getCacheLocations(widget.accessToken);
    allCaches = cacheLocations;

    setState(() {
      _cacheMarkers.clear();
      _allCaches = cacheLocations.caches;
      for (final cache in cacheLocations.caches) {
        final coords = LatLng(cache.lat, cache.lng);
        final marker = Marker(
          markerId: MarkerId(cache.name),
          position: coords,
          onTap: () {
            if (_userLocatedAtUCF == true && _destination != coords) {
              setState(() {
                _destination = coords;
              });
            } else if (_destination == coords) {
              setState(() {
                _destination = null;
              });
            }
          },
          infoWindow: InfoWindow(
            title: cache.name,
          ),
        );
        _cacheMarkers[cache.name] = marker;
      }
      _cacheLocationsLoaded = true;
    });
  }

  bool userAtUCF(double userLat, double userLng) {
    double distanceInMeters = Geolocator.distanceBetween(
        ucfCampusCenter.latitude, ucfCampusCenter.longitude, userLat, userLng);

    // Check if the user is within the defined radius of UCF campus
    return distanceInMeters <= ucfCampusRadius;
  }

  void _updateCameraPosition(double lat, double lng) {
    var userLocation = LatLng(lat, lng);
    var userInUCF = userAtUCF(lat, lng);

    if (userInUCF == false) {
      userLocation = ucfCampusCenter;
    }

    setState(() {
      _currentLocation = userLocation;
      _userLocatedAtUCF = userInUCF;
      _userLocationLoaded = true;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

// Asks for the user's location and returns error if unavailable.
  void _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog(
        context,
        "Location Services Disabled",
        "Location services are disabled. Please enable them in settings.",
      );
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorDialog(
          context,
          "Location Permission Denied",
          "Location permissions are denied. Please enable them in settings.",
        );
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Show dialog that explains the user needs to enable permissions manually
      _showErrorDialog(
        context,
        "Location Permission Permanently Denied",
        "Location permissions are permanently denied. Please enable them in settings.",
        openAppSettings: true, // Pass flag to open settings if needed
      );
      return Future.error(
          'Location permissions are permanently denied, we cannot request your location');
    }

    // Get the user's current location
    var position = await Geolocator.getCurrentPosition();

    _updateCameraPosition(position.latitude, position.longitude);

    _updateLiveLocation();
  }

// Show a dialog to handle location permission issues
  void _showErrorDialog(BuildContext context, String title, String message,
      {bool openAppSettings = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            if (openAppSettings)
              TextButton(
                onPressed: () {
                  Geolocator
                      .openAppSettings(); // Open app settings via Geolocator
                  Navigator.of(context).pop();
                },
                child: const Text("Open Settings"),
              ),
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _updateLiveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.best,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      _updateCameraPosition(position.latitude, position.longitude);
    });
  }

  CameraPosition getUserLocationCameraView() {
    return CameraPosition(
        target: _currentLocation, zoom: initialMapZoomOnVentureScreen);
  }

  GoogleMap createNavigationPanel() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      polylines: _destination != null
          ? {
              Polyline(
                polylineId: const PolylineId("route"),
                points: [_currentLocation, _destination!],
                color: Colors.blue,
                width: 6,
              ),
            }
          : {},
      initialCameraPosition: getUserLocationCameraView(),
      markers: _cacheMarkers.values.toSet(),
      minMaxZoomPreference: const MinMaxZoomPreference(16, 20),
      cameraTargetBounds: CameraTargetBounds(
        LatLngBounds(
          northeast: ucfNECorner, // Northeast corner
          southwest: ucfSWCorner, // Southwest corner
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Shows loading screen until user location and all the caches load.
    Widget content = const VentureLoadingScreen();
    if (_userLocationLoaded && _cacheLocationsLoaded) {
      content = Stack(
        children: [
          createNavigationPanel(),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // Recenter the map on the user's location if they're at UCF
                var newLocation = _currentLocation;
                if (userAtUCF(newLocation.latitude, newLocation.longitude) ==
                    false) {
                  newLocation = ucfCampusCenter;
                }
                _mapController.moveCamera(CameraUpdate.newLatLng(newLocation));
              },
              child: const Icon(Icons.my_location),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: GestureDetector(
                onTap: () {
                  if (_allCaches.isNotEmpty) {
                    caches.Cache closestCache = _allCaches.reduce((a, b) {
                      double distanceA = Geolocator.distanceBetween(
                          _currentLocation.latitude,
                          _currentLocation.longitude,
                          a.lat,
                          a.lng);
                      double distanceB = Geolocator.distanceBetween(
                          _currentLocation.latitude,
                          _currentLocation.longitude,
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
                              color: Colors.black.withOpacity(
                                  0.8), // Black with slight transparency
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
                                    closestCache.desc ??
                                        'No description available',
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
                                      backgroundColor:
                                          Colors.yellow, // Text color
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
                  }
                },
                child: Image.asset(
                  "assets/logo.png",
                  width: 160,
                  height: 160,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(body: content);
  }
}
