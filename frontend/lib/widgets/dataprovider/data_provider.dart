import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/caches.dart';
import 'package:frontend/models/user_profile.dart';
import 'package:frontend/models/user_rankings.dart';
import 'package:frontend/utils/pathbuilder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class DataProvider with ChangeNotifier {
  bool _isLoading = true;
  UserRanking? _userRanking;
  UserProfile? _userProfile;
  UserCaches? _userCaches;
  BitmapDescriptor _unfoundIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _foundIcon = BitmapDescriptor.defaultMarker;

  bool get isLoading => _isLoading;
  UserRanking? get userRanking => _userRanking;
  UserProfile? get userProfile => _userProfile;
  UserCaches? get userCaches => _userCaches;
  BitmapDescriptor get unfoundIcon => _unfoundIcon;
  BitmapDescriptor get foundIcon => _foundIcon;

  void updateUserFullName(String fullName, String accessToken) async {
    // Store the current full name to revert in case of an error
    final previousFullName = _userProfile?.fullName;

    // Optimistically update the state immediately
    if (_userProfile != null) {
      _userProfile!.fullName = fullName;
      notifyListeners();
    }

    // Call the update profile API to update the user's full name
    final String apiUrl = buildPath("api/update_profile");
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fullName': fullName,
          'accessToken': accessToken,
        }),
      );

      if (response.statusCode == 200) {
        print("Profile updated successfully");
        // If successful, we’re done
      } else {
        // Handle error response here
        print('Failed to update profile: ${response.statusCode}');
        // Optionally revert the update
        if (previousFullName != null) {
          _userProfile!.fullName = previousFullName;
          notifyListeners();
        }
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error updating profile: $e');
      // Revert the update if an error occurs
      if (previousFullName != null) {
        _userProfile!.fullName = previousFullName;
        notifyListeners();
      }
    }
  }

  void _updateUserPoints(String username, int points) {
    if (_userProfile != null) {
      _userProfile!.points += points;
    }
    // Update points in the user ranking and resort
    if (_userRanking != null) {
      for (var entry in _userRanking!.sortedUserRankings) {
        // Assuming _userRanking is a list of user entries
        if (entry.username == username) {
          entry.points += points; // Update points for the matching user
          break;
        }
      }
      // Resort rankings based on points, in descending order
      _userRanking!.sortedUserRankings
          .sort((a, b) => b.points.compareTo(a.points));
    }
  }

  void confirmCacheFind(String cacheId, int points, String username,
      String accessToken, BuildContext buildContext, BuildContext quizContext) async {
    final previousUserRanking = userRanking?.sortedUserRankings ?? [];
    final previousUserPoints = userProfile?.points ?? 0;

    final url = Uri.parse(buildPath("api/confirm_cache"));

    // Optimistically update cachesFound locally
    if (_userProfile != null) {
      _userProfile!.cachesFound += 1;
    }

    if (_userCaches != null) {
      _userCaches!.addFoundCache(cacheId);
    }

    _updateUserPoints(username, points);
    notifyListeners();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'cacheId': cacheId,
          'accessToken':
              accessToken, // Send the token as part of the payload if required by your backend
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Show success dialog
        showDialog(
          context: buildContext,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cache Found!'),
              content: Text(responseData['message']),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(quizContext).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // If there's an error, revert the optimistic update
        print('Error: ${response.body}');
        if (_userProfile != null) {
          _userProfile!.cachesFound -= 1;
          _userProfile!.points = previousUserPoints;
        }
        if (_userCaches != null) {
          _userCaches!.foundCaches.remove(cacheId);
        }
        if (_userRanking != null) {
          _userRanking!.sortedUserRankings = previousUserRanking;
        }
        notifyListeners();
      }
    } catch (e) {
      print('Error confirming cache find: $e');
      // Revert count change on error
      if (_userProfile != null) {
        _userProfile!.cachesFound -= 1;
        _userProfile!.points = previousUserPoints;
      }
      if (_userCaches != null) {
        _userCaches!.removeFoundCache(cacheId);
      }
      if (_userRanking != null) {
        _userRanking!.sortedUserRankings = previousUserRanking;
      }
      notifyListeners();
    }
  }

  Future<void> loadCacheIcons() async {
    final prevUnfoundIcon = _unfoundIcon;
    final prevFoundIcon = _foundIcon;
    try {
      _unfoundIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(24, 24)),
        'assets/unfound_cache_marker.png',
      );

      _foundIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(24, 24)),
        'assets/found_cache_marker.png',
      );
    } catch (e) {
      print("Error loading icons: $e");
      _unfoundIcon = prevUnfoundIcon;
      _foundIcon = prevFoundIcon;
    }
  }

  Future<void> loadUserData(String accessToken, String username) async {
    _isLoading = true;
    notifyListeners(); // Notifying listeners to show loading state

    try {
      // Run both calls concurrently
      final results = await Future.wait([
        getUserRankings(accessToken, username),
        getUserProfile(accessToken),
        getCacheLocations(accessToken, username),
      ]);

      _userRanking = results[0] as UserRanking?;
      _userProfile = results[1] as UserProfile?;
      _userCaches = results[2] as UserCaches?;
      await loadCacheIcons();
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifying listeners to hide loading state and show data
    }
  }
}
