import 'package:flutter/foundation.dart';
import 'package:frontend/models/user_rankings.dart';

class DataProvider with ChangeNotifier {
  bool _isLoading = true;
  UserRanking? _userRanking;

  bool get isLoading => _isLoading;
  UserRanking? get userRanking => _userRanking;

  Future<void> loadUserData(String accessToken, String username) async {
    _isLoading = true;
    notifyListeners();  // Notifying listeners to show loading state

    try {
      _userRanking = await getUserRankings(accessToken, username);
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();  // Notifying listeners to hide loading state and show data
    }
  }
}
