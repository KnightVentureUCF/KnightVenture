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
            setState(() {
              _destination = coords;
            });
          },
          infoWindow: InfoWindow(
            title: cache.name,
          ),
        );
        _cacheMarkers[cache.name] = marker;
      }
    });
  }

  void _updateCameraPosition(double lat, double lng) {
    setState(() {
      _currentLocation = LatLng(lat, lng);
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

    final position = await Geolocator.getCurrentPosition();

    _updateCameraPosition(position.latitude, position.longitude);

    _updateLiveLocation();
  }

  void _updateLiveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
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
      myLocationButtonEnabled: true,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    // Shows loading screen until user location and all the caches load.
    Widget content = const VentureLoadingScreen();
    if (_isLoading == false) {
      content = createNavigationPanel();
    }

    return Scaffold(
      body: content,
    );
  }
}
