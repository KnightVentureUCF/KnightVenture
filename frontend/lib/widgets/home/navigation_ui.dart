import "package:flutter/material.dart";
import "package:frontend/widgets/dataprovider/data_provider.dart";
import "package:frontend/widgets/home/navigation_button.dart";
import "package:frontend/widgets/home/quiz_popup.dart";
import "package:frontend/widgets/home/loading_screen.dart";
import "package:frontend/widgets/home/venture_button.dart";
import "package:frontend/widgets/main_menu/main_menu_screen.dart";
import "package:frontend/widgets/styling/theme.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:geolocator/geolocator.dart";
import "package:frontend/models/caches.dart" as caches;
import "package:frontend/constants.dart" show initialMapZoomOnVentureScreen;
import "package:provider/provider.dart";

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
  bool _userLocationLoaded = false;

  // Variables for cache navigation and quiz popup
  caches.Cache? _destination;
  bool _reachedDestination = false;
  static const double reachedDestinationThreshold = 20;

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
  }

  List<Marker> _createCacheMarkers(DataProvider dataProvider) {
    final cacheLocations = dataProvider.userCaches;
    final foundCaches = cacheLocations?.foundCaches ?? {};
    final caches = cacheLocations?.caches ?? [];

    return caches.map((cache) {
      final coords = LatLng(cache.lat, cache.lng);
      final icon = foundCaches.contains(cache.id)
          ? dataProvider.foundIcon
          : dataProvider.unfoundIcon;

      return Marker(
        markerId: MarkerId(cache.id),
        position: coords,
        icon: icon,
        onTap: () => _showCacheInfo(
            cache, foundCaches.contains(cache.id) || _destination == cache),
      );
    }).toList();
  }

  void beginCacheNavigation(bool userLocatedAtUCF, caches.Cache cache) {
    if (_userLocatedAtUCF == true && _destination != cache) {
      setState(() {
        _destination = cache;
        _reachedDestination = false;
      });
    }
  }

  void exitCacheNavigation() {
    setState(() {
      _destination = null;
      _reachedDestination = false;
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
      backgroundColor: Colors.black.withOpacity(0.9),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          widthFactor: 1.0,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: brightGold,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Image.network(
                          cache.iconUrl ?? 'assets/default_cache_icon.png',
                          width: 55,
                          height: 55,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        cache.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      cache.desc ?? 'No description available',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.security,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Difficulty: ${cache.points ?? 'Unknown'}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 20),
                if (!cacheHasBeenFound && _userLocatedAtUCF)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: ElevatedButton(
                      onPressed: () {
                        beginCacheNavigation(_userLocatedAtUCF, cache);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.yellow,
                      ),
                      child: const Text(
                        'Start!',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
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

  GoogleMap createNavigationPanel(DataProvider dataProvider) {
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
      markers: _createCacheMarkers(dataProvider).toSet(),
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
    final dataProvider = Provider.of<DataProvider>(context);
    // Shows loading screen until user location and all the caches load.
    Widget content = const VentureLoadingScreen();

    if (_userLocationLoaded) {
      content = Stack(
        children: [
          createNavigationPanel(dataProvider),
          Positioned(
            top: 75,
            right: 35,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainMenuScreen(
                      accessToken: widget.accessToken,
                      username: widget.username,
                      allCaches: dataProvider.userCaches?.caches ?? [],
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.menu,
                size: 48,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                if (_reachedDestination)
                  QuizPopup(
                    cache: _destination!,
                    accessToken: widget.accessToken,
                    username: widget.username,
                    exitCacheNavigation: exitCacheNavigation,
                  ),
                if (_destination == null)
                  VentureButton(
                    allCaches: dataProvider.userCaches?.caches.where((cache) {
                          return !dataProvider.userCaches!.foundCaches
                              .contains(cache.id);
                        }).toList() ??
                        [],
                    currentLocation: _currentLocation,
                    beginCacheNavigation: beginCacheNavigation,
                    userLocatedAtUCF: _userLocatedAtUCF,
                    showCacheInfo: _showCacheInfo,
                  )
                else
                  NavigationButton(
                      onPressed: exitCacheNavigation,
                      buttonText: _reachedDestination ? "X" : "Exit"),
              ])),
          if (_reachedDestination == false)
            Positioned(
              bottom: 30,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  // Recenter the map on the user's location if they're at UCF
                  var newLocation = _currentLocation;
                  if (userAtUCF(newLocation.latitude, newLocation.longitude) ==
                      false) {
                    newLocation = ucfCampusCenter;
                  }
                  _mapController
                      .moveCamera(CameraUpdate.newLatLng(newLocation));
                },
                child: const Icon(Icons.my_location),
              ),
            )
        ],
      );
    }

    return Scaffold(body: content);
  }
}
