// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_rankings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      username: json['userid'] as String,
      points: (json['points'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userid': instance.username,
      'points': instance.points,
    };

UserRanking _$UserRankingFromJson(Map<String, dynamic> json) => UserRanking(
      sortedUserRankings: (json['users'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserRankingToJson(UserRanking instance) =>
    <String, dynamic>{
      'users': instance.sortedUserRankings,
    };
