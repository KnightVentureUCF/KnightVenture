import "dart:ffi";

import "package:flutter/material.dart";
import "package:frontend/components/markers.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:geolocator/geolocator.dart";
import "package:frontend/models/locations.dart" as locations;

// TODO:
// DONE - Figure out how to import this from env file
// DONE - Center map over UCF
// DONE - Enable following user location
// DONE - Have user location update automatically
// DONE - Have user location update live
// Add custom locations and markers
// Enable point to point navigation
// Setup AWS to store custom locations
// Create API to get locations
// Set all initial API calls to occur on the loading page
// Setup loading page
// Comment

const mapZoom = 18.0;
const userLocationUpdateDistance = 100;

class NavigationUI extends StatefulWidget {
  const NavigationUI({super.key});

  @override
  State<NavigationUI> createState() => _NavigationUIState();
}

class _NavigationUIState extends State<NavigationUI> {
  late GoogleMapController _mapController;
  CameraPosition _initialCameraPosition = const CameraPosition(
    target: ucfCoords,
    zoom: mapZoom,
  );
  bool _isLoading = true;
  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadInitialUserLocation();
    _loadMarkers();
  }

  void _loadMarkers() async {
    final googleOffices = await locations.getGoogleOffices();

    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  void _loadInitialUserLocation() async {
    final position = await _getCurrentLocation();
    _updateCameraPosition(position);
  }

  void _updateCameraPosition(Position position) {
    setState(() {
      _initialCameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: mapZoom);
      _isLoading = false;
    });
    // _mapController
    //     .animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
  }

  // TODO: Make this change to the user's current location immediately using set state
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _getLiveLocation();
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
      return Future.error(
          'Location permissions are permanently denied, we cannot request your location');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _getLiveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: userLocationUpdateDistance,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      _updateCameraPosition(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: change loading widget to loading screen
    Widget content = const Center(child: CircularProgressIndicator());
    if (_isLoading == false) {
      content = GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        markers: _markers.values.toSet(),
      );
    }

    return Scaffold(
      // Creates the map
      body: content,

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
