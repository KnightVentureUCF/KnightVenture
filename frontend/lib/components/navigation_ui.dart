import "dart:ffi";

import "package:flutter/material.dart";
import "package:frontend/components/locations.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

// TODO:
// DONE - Figure out how to import this from env file
// DONE - Center map over UCF
// Enable custom locations
// Enable following user location
// Enable point to point navigation
// Create firebase with locations
// Create API to get locations

class NavigationUI extends StatefulWidget {
  const NavigationUI({super.key});

  @override
  State<NavigationUI> createState() => _NavigationUIState();
}

class _NavigationUIState extends State<NavigationUI> {
  late GoogleMapController mapController;

  static const _initialCameraPosition = CameraPosition(
    target: sanFranCoords,
    zoom: 18.0,
  );

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
        onPressed: () => mapController.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}
