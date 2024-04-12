import "dart:ffi";

import "package:flutter/material.dart";
import "package:frontend/components/ucf_details.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

// TODO: 
    // DONE - Figure out how to import this from env file
    // Center map over UCF
    // Enable navigation
    // Enable custom locations
    // Create firebase with locations
    // Create API to get locations

class NavigationUI extends StatefulWidget {
  const NavigationUI({super.key});

  @override
  State<NavigationUI> createState() => _NavigationUIState();
}

class _NavigationUIState extends State<NavigationUI> {
  late GoogleMapController mapController;

  final LatLng _center = UCFDetails.location;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 18.0,
      ),
    );
  }
}
