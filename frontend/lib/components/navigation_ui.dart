import "dart:ffi";

import "package:flutter/material.dart";
import "package:frontend/components/markers.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:geolocator/geolocator.dart";
import "package:frontend/models/caches.dart" as caches;

// TODO:
// DONE - Figure out how to import this from env file
// DONE - Center map over UCF
// DONE - Enable following user location
// DONE - Have user location update automatically
// DONE - Have user location update live
// DONE - Add custom locations and markers
// - Set a marker on user location
// - Enable point to point navigation
// - Setup firebase to store custom locations
// - Create API to get locations
// - Set all initial API calls to occur on the loading page
// - Setup loading page
// - Comment

const mapZoom = 18.0;
const userLocationUpdateDistance = 100;

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
    // TODO: implement initState
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
            // TODO: Add more to this info window and change the location.
            // TODO: set a custom icon.
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
    // _mapController
    //     .animateCamera(CameraUpdate.newCameraPosition(_currentLocation));
  }

  // TODO: Make this change to the user's current location immediately using set state
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

  @override
  Widget build(BuildContext context) {
    // TODO: change loading widget to loading screen
    Widget content = const Center(child: CircularProgressIndicator());
    if (_isLoading == false) {
      CameraPosition cameraPosition =
          CameraPosition(target: _currentLocation, zoom: mapZoom);

      content = GoogleMap(
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
          initialCameraPosition: cameraPosition,
          markers: {
            ..._cacheMarkers.values.toSet(),
            // Marker(
            //     markerId: const MarkerId("currentLocation"),
            //     position: _currentLocation),
          });
    }

    return Scaffold(
      // Creates the map
      body: content,

      // Creates a button to return screen to user's location
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   foregroundColor: Colors.black,
      //   onPressed: () => _mapController.animateCamera(
      //     CameraUpdate.newCameraPosition(cameraPosition),
      //   ),
      //   child: const Icon(Icons.center_focus_strong),
      // ),
    );
  }
}
