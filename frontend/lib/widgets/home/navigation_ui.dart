import "dart:ffi";

import "package:flutter/material.dart";
import "package:frontend/widgets/home/loading_screen.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:geolocator/geolocator.dart";
import "package:frontend/models/caches.dart" as caches;
import "package:frontend/constants.dart" show initialMapZoomOnVentureScreen;

class NavigationUI extends StatefulWidget {
  const NavigationUI({super.key});

  @override
  State<NavigationUI> createState() => _NavigationUIState();
}

class _NavigationUIState extends State<NavigationUI> {
  late GoogleMapController _mapController;
  late LatLng _currentLocation;
  LatLng? _destination;
  bool _isLoading = true;
  final Map<String, Marker> _cacheMarkers = {};

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
    _loadCacheMarkers();
    _getCurrentLocation();
  }

  void _loadCacheMarkers() async {
    final cacheLocations = await caches.getCacheLocations();

    setState(() {
      _cacheMarkers.clear();
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
            }
            else if (_destination == coords) {
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
      _isLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  // Asks for the user's location and returns error if unavailable.
  void _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request your location');
    }

    var position = await Geolocator.getCurrentPosition();

    _updateCameraPosition(position.latitude, position.longitude);

    _updateLiveLocation();
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
    if (_isLoading == false) {
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
        ],
      );
    }

    return Scaffold(body: content);
  }
}
