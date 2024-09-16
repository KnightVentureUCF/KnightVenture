// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caches.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) => QuizQuestion(
      json['text'] as String,
      (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$QuizQuestionToJson(QuizQuestion instance) =>
    <String, dynamic>{
      'text': instance.text,
      'answers': instance.answers,
    };

Cache _$CacheFromJson(Map<String, dynamic> json) => Cache(
      name: json['Name'] as String,
      desc: json['Description'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      imgUrl: json['Image'] as String?,
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CacheToJson(Cache instance) => <String, dynamic>{
      'Name': instance.name,
      'Description': instance.desc,
      'lat': instance.lat,
      'lng': instance.lng,
      'Image': instance.imgUrl,
      'questions': instance.questions,
    };

Caches _$CachesFromJson(Map<String, dynamic> json) => Caches(
      caches: (json['caches'] as List<dynamic>)
          .map((e) => Cache.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CachesToJson(Caches instance) => <String, dynamic>{
      'caches': instance.caches,
    };
