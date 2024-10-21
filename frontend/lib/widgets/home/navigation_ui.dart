import "package:flutter/material.dart";
import "package:frontend/widgets/home/quiz_popup.dart";
import "package:frontend/widgets/home/loading_screen.dart";
import "package:frontend/widgets/home/venture_button.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:geolocator/geolocator.dart";
import "package:frontend/models/caches.dart" as caches;
import "package:frontend/constants.dart" show initialMapZoomOnVentureScreen;

class NavigationUI extends StatefulWidget {
  final String accessToken; // Add accessToken as a final field
  final String username;

  const NavigationUI(
      {super.key,
      required this.accessToken,
      required this.username}); // Add accessToken as a named required parameter

  @override
  State<NavigationUI> createState() => _NavigationUIState();
}

class _NavigationUIState extends State<NavigationUI> {
  late GoogleMapController _mapController;

  // Used to load and store user and cache locations
  late LatLng _currentLocation;
  bool _cacheLocationsLoaded = false;
  bool _userLocationLoaded = false;
  final Map<String, Marker> _cacheMarkers = {};
  List<caches.Cache> _allCaches = [];
  Set<String> _foundCaches = {};

  // Variables for cache navigation and quiz popup
  caches.Cache? _destination;
  bool _reachedDestination = false;
  static const double reachedDestinationThreshold = 15;

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
    final cacheLocations =
        await caches.getCacheLocations(widget.accessToken, widget.username);
    final foundCaches = cacheLocations.userCachesFound;

    final BitmapDescriptor unfoundIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(24, 24)),
      'assets/unfound_cache_marker.png',
    );

    final BitmapDescriptor foundIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(24, 24)),
      'assets/found_cache_marker.png',
    );

    setState(() {
      _cacheMarkers.clear();
      _allCaches = cacheLocations.caches;
      _foundCaches = Set.from(foundCaches);
      for (final cache in _allCaches) {
        final coords = LatLng(cache.lat, cache.lng);
        final marker = Marker(
          markerId: MarkerId(cache.id),
          position: coords,
          icon: _foundCaches.contains(cache.id) ? foundIcon : unfoundIcon,
          onTap: () => {
            if (_destination != cache)
              {_showCacheInfo(cache, _foundCaches.contains(cache.id))}
            else if (!_foundCaches.contains(cache.id))
              {
                setState(() {
                  _destination = null;
                })
              }
          },
        );
        _cacheMarkers[cache.id] = marker;
      }
      _cacheLocationsLoaded = true;
    });
  }

  void beginCacheNavigation(bool userLocatedAtUCF, caches.Cache cache) {
    if (_userLocatedAtUCF == true && _destination != cache) {
      setState(() {
        _destination = cache;
      });
    } else if (_destination == cache) {
      setState(() {
        _destination = null;
      });
    }
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
    var reachedDestination = false;

    if (userInUCF == false) {
      userLocation = ucfCampusCenter;
    }
    if (_destination != null) {
      double distanceToCache = Geolocator.distanceBetween(
          _currentLocation.latitude,
          _currentLocation.longitude,
          _destination!.lat,
          _destination!.lng);

      reachedDestination = distanceToCache < reachedDestinationThreshold;
    }

    setState(() {
      _currentLocation = userLocation;
      _userLocatedAtUCF = userInUCF;
      _reachedDestination = reachedDestination;
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
    setState(() {
      _userLocationLoaded = true;
    });

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

  void _showCacheInfo(caches.Cache cache, bool cacheHasBeenFound) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent, // This makes the entire sheet transparent
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 75, // Set the maximum height here
                          ),
                          child: SingleChildScrollView(
                            child: Center(
                              child: Text(
                                cache.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: SingleChildScrollView(
                      child: Text(
                        cache.desc ?? 'No description available',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Spacer(),
                  !cacheHasBeenFound
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _destination = cache;
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.yellow,
                            ),
                            child: const Text('Start!',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
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
                points: [
                  _currentLocation,
                  LatLng(_destination!.lat, _destination!.lng)
                ],
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
          _destination == null
              ? VentureButton(
                  allCaches: _allCaches.where((cache) {
                    return !_foundCaches.contains(cache.id);
                  }).toList(),
                  currentLocation: _currentLocation,
                  beginCacheNavigation: beginCacheNavigation,
                  userLocatedAtUCF: _userLocatedAtUCF,
                )
              : const SizedBox.shrink(),
          _destination != null && _reachedDestination
              ? QuizPopup(
                  cache: _destination!,
                  accessToken: widget.accessToken,
                  username: widget.username)
              : const SizedBox.shrink()
        ],
      );
    }

    return Scaffold(body: content);
  }
}
