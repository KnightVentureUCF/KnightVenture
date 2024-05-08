import 'dart:convert';
import "package:google_maps_flutter/google_maps_flutter.dart";
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'caches.g.dart';

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

@JsonSerializable()
class Cache {
  Cache({
    required this.name,
    required this.desc,
    required this.lat,
    required this.lng,
    required this.imgUrl,
    required this.questions,
  });

  factory Cache.fromJson(Map<String, dynamic> json) => _$CacheFromJson(json);
  Map<String, dynamic> toJson() => _$CacheToJson(this);

  final String name;
  final String desc;
  final double lat;
  final double lng;
  final String imgUrl;
  final List<QuizQuestion> questions;
}

@JsonSerializable()
class Caches {
  Caches({
    required this.caches,
  });

  factory Caches.fromJson(Map<String, dynamic> json) => _$CachesFromJson(json);
  Map<String, dynamic> toJson() => _$CachesToJson(this);

  final List<Cache> caches;
}

Future<Caches> getCacheLocations() async {
  const cacheLocationsURL = 'TODO';

  // Retrieve the locations of Google offices
  try {
    final response = await http.get(Uri.parse(cacheLocationsURL));
    if (response.statusCode == 200) {
      return Caches.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  // Fallback for when the above HTTP request fails.
  return Caches.fromJson(
    json.decode(
      await rootBundle.loadString('lib/data/cache-locations.json'),
    ) as Map<String, dynamic>,
  );
}
