import 'dart:convert';
import 'package:frontend/utils/pathbuilder.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'caches.g.dart';

// Takes in data for cache questions from API calls.
@JsonSerializable()
class QuizQuestion {
  const QuizQuestion(this.text, this.answers);

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuizQuestionToJson(this);

  final String text;
  final List<String> answers;

  List<String> getShuffledAnswers() {
    final randomizedAnswers = List.of(answers);
    randomizedAnswers.shuffle();
    return randomizedAnswers;
  }
}

// Takes in data for individual caches from API calls.
@JsonSerializable()
class Cache {
  Cache({
    required this.id,
    required this.name,
    this.desc,
    required this.lat,
    required this.lng,
    this.imgUrl,
    this.iconUrl,
    this.questions,
    this.difficulty,
    this.points,
  });

  factory Cache.fromJson(Map<String, dynamic> json) => _$CacheFromJson(json);
  Map<String, dynamic> toJson() => _$CacheToJson(this);

  final String id;
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'Description')
  final String? desc;
  final double lat;
  final double lng;
  @JsonKey(name: 'Image')
  final String? imgUrl;
  @JsonKey(name: 'Icon')
  final String? iconUrl;
  final List<QuizQuestion>? questions;
  @JsonKey(name: 'Difficulty')
  final int? difficulty;
  @JsonKey(name: 'Size')
  final int? points;
}

@JsonSerializable()
class UserCaches {
  UserCaches({
    required this.caches,
    required Set<String> foundCaches,
  }) : _foundCaches = foundCaches.toList();

  factory UserCaches.fromJson(Map<String, dynamic> json) =>
      _$UserCachesFromJson(json);
  Map<String, dynamic> toJson() => _$UserCachesToJson(this);

  @JsonKey(name: 'foundCaches')
  final List<String> _foundCaches;

  @JsonKey(name: 'allCaches')
  final List<Cache> caches;

  // Provide a Set view of _foundCaches for easy use
  Set<String> get foundCaches => _foundCaches.toSet();

  // Method to add a cache ID to the _foundCaches list
  void addFoundCache(String cacheId) {
    if (!_foundCaches.contains(cacheId)) {
      _foundCaches.add(cacheId);
    }
  }

  // Method to remove a cache ID from the _foundCaches list
  void removeFoundCache(String cacheId) {
    _foundCaches.remove(cacheId);
  }
}

// function to call load caches API for venture page.
Future<UserCaches?> getCacheLocations(
    String accessToken, String username) async {
  final url = Uri.parse(buildPath("api/load_caches"));

  try {
    // Including the access token in the request body
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'accessToken': accessToken, // Adding the access token in the body
        'username': username
      }),
    );

    if (response.statusCode == 200) {
      return UserCaches.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load caches');
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
