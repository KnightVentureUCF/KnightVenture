import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:frontend/models/user_profile.dart';
import 'package:frontend/models/user_rankings.dart';
import 'package:frontend/utils/pathbuilder.dart';
import 'package:http/http.dart' as http;

class DataProvider with ChangeNotifier {
  bool _isLoading = true;
  UserRanking? _userRanking;
  UserProfile? _userProfile;

  bool get isLoading => _isLoading;
  UserRanking? get userRanking => _userRanking;
  UserProfile? get userProfile => _userProfile;

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
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fullName': fullName,
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

  void updateUserPoints(String username, int points) {
    if (_userProfile != null) {
      _userProfile!.points = points;
    }
    // Update points in the user ranking and resort
    if (_userRanking != null) {
      for (var entry in _userRanking!.sortedUserRankings) {
        // Assuming _userRanking is a list of user entries
        if (entry.username == username) {
          entry.points = points; // Update points for the matching user
          break;
        }
      }
      // Resort rankings based on points, in descending order
      _userRanking!.sortedUserRankings
          .sort((a, b) => b.points.compareTo(a.points));
    }
    // Notify listeners about changes
    notifyListeners();
  }

  void updateUserCachesFound(int cachesFound) {
    if (_userProfile != null) {
      _userProfile!.cachesFound = cachesFound;
      notifyListeners();
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
      ]);

      _userRanking = results[0] as UserRanking?;
      _userProfile = results[1] as UserProfile?;
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifying listeners to hide loading state and show data
    }
  }
}
