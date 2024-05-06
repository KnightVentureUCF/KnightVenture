import "dart:ffi";

import "package:flutter/material.dart";
import "package:frontend/components/markers.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:geolocator/geolocator.dart";

// TODO:
// DONE - Figure out how to import this from env file
// DONE - Center map over UCF
// DONE - Enable following user location
// Have user location update automatically and live
// Add custom locations
// Enable point to point navigation
// Create S3 Bucket with locations
// Create API to get locations
// Set all initial API calls to occur on the loading page

class NavigationUI extends StatefulWidget {
  const NavigationUI({super.key});

  @override
  State<NavigationUI> createState() => _NavigationUIState();
}

class _NavigationUIState extends State<NavigationUI> {
  late GoogleMapController _mapController;

  // Initial camera position if user location unavailable
  static var _initialCameraPosition = const CameraPosition(
    target: ucfCoords,
    zoom: 18.0,
  );

  // TODO: Make this change to the user's current location immediately using set state
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _getCurrentLocation().then((value) => {
      _initialCameraPosition = CameraPosition(target: LatLng(value.latitude, value.longitude), zoom: 18.0)
    });
    _mapController.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition),
    );
  }

  // Asks for the user's location and returns error if unavailable.
  Future<Position> _getCurrentLocation() async {
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
      return Future.error('Location permissions are permanently denied, we cannot request your location');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Creates the map
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
      ),

      // Creates a button to return screen to user's location
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _mapController.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}
