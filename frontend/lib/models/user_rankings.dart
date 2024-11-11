import 'dart:convert';
import 'package:frontend/utils/pathbuilder.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'user_rankings.g.dart';

// Takes in data for individual caches from API calls.
@JsonSerializable()
class User {
  User({
    required this.username,
    this.points = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @JsonKey(name: 'userid')
  final String username;
  @JsonKey(defaultValue: 0)
  int points;
}

// Takes in all Cache data, along with a user's found caches
@JsonSerializable()
class UserRanking {
  UserRanking({required this.sortedUserRankings});

  factory UserRanking.fromJson(Map<String, dynamic> json) =>
      _$UserRankingFromJson(json);
  Map<String, dynamic> toJson() => _$UserRankingToJson(this);

  @JsonKey(name: 'users')
  List<User> sortedUserRankings;
}

// function to call load caches API for venture page.
Future<UserRanking?> getUserRankings(String accessToken) async {
  final url = Uri.parse(buildPath("api/read_ranking"));

  try {
    // Including the access token in the request body
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'accessToken': accessToken, // Adding the access token in the body
      }),
    );

    if (response.statusCode == 200) {
      return UserRanking.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load user rankings');
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
