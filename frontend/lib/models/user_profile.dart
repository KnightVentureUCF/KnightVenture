import 'dart:convert';
import 'package:frontend/utils/pathbuilder.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

const defaultFullName = "Full Name";
const defaultEmail = "xxx@gmail.com";
const defaultPoints = 0;
const defaultCachesFound = 0;

// Takes in user profile data from API calls
@JsonSerializable()
class UserProfile {
  UserProfile({
    this.fullName = defaultFullName,
    this.email = defaultEmail,
    this.points = defaultPoints,
    this.cachesFound = defaultCachesFound,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  @JsonKey(defaultValue: defaultFullName)
  String fullName;
  @JsonKey(name: 'point', defaultValue: defaultPoints)
  int points;
  @JsonKey(defaultValue: defaultEmail)
  final String email;
  @JsonKey(defaultValue: defaultCachesFound)
  int cachesFound;
}

Future<UserProfile?> getUserProfile(String accessToken) async {
  try {
    final String apiUrl = buildPath("api/get_profile");

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'accessToken': accessToken,
      }),
    );

    if (response.statusCode == 200) {
      // Decode the response body and access 'profileData'
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> profileData = data['profileData'];

      return UserProfile.fromJson(profileData);
    } else {
      throw Exception('Failed to load user profile');
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
